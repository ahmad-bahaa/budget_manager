import 'package:budget_manager/services/shared_preferences.dart';
import 'package:budget_manager/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';

// // Example of how to filter in your main transaction provider
// final boundaries = BudgetCycleUtils.getCycleBoundaries(startDay);
//
// final currentCycleTransactions = allTransactions.where((tx) {
//   return tx.date.isAfter(boundaries['start']!.subtract(const Duration(seconds: 1))) &&
//       tx.date.isBefore(boundaries['end']!.add(const Duration(seconds: 1)));
// }).toList();

// 1. Current Date State (for filtering by month)
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final cycleStartDayProvider = StateNotifierProvider<CycleStartDayNotifier, int>(
  (ref) {
    return CycleStartDayNotifier();
  },
);

// 2. Categories Provider (AsyncNotifier pattern)
class CategoriesNotifier
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  CategoriesNotifier() : super(const AsyncValue.loading()) {
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    debugPrint('Fetching categories...');
    try {
      final categories = await DatabaseHelper.instance.getAllCategories();
      debugPrint('Categories fetched: ${categories.length}');
      state = AsyncValue.data(categories);
    } catch (e, stack) {
      debugPrint('Error fetching categories: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    await DatabaseHelper.instance.createCategory(category);
    await PreferencesService().updateLastUpdated();
    await _fetchCategories(); // Refresh list
  }

  Future<void> updateCategory(CategoryModel category) async {
    if (category.id == null) return;
    await DatabaseHelper.instance.update('categories', category.toMap());
    await PreferencesService().updateLastUpdated();
    await _fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    await DatabaseHelper.instance.delete('categories', id);
    await PreferencesService().updateLastUpdated();
    await _fetchCategories();
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, AsyncValue<List<CategoryModel>>>(
      (ref) => CategoriesNotifier(),
    );

// 3. Transactions Provider (AsyncNotifier pattern)
// Listens to selectedDateProvider to filter data automatically.
class TransactionsNotifier
    extends StateNotifier<AsyncValue<List<TransactionModel>>> {
  final Ref ref;

  TransactionsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    await _fetchTransactionsCycle();
    // Use Future.microtask to avoid blocking the initial build/load
    Future.microtask(() => checkRecurringTransactions());
  }

  Future<void> checkRecurringTransactions() async {
    try {
      final recurring = await DatabaseHelper.instance.getRecurringTransactions();
      final now = DateTime.now();
      bool addedAny = false;

      for (var tx in recurring) {
        DateTime lastProcessed = tx.lastProcessedDate ?? tx.date;
        DateTime nextDate;

        switch (tx.recurrenceInterval) {
          case 'daily':
            nextDate = lastProcessed.add(const Duration(days: 1));
            break;
          case 'weekly':
            nextDate = lastProcessed.add(const Duration(days: 7));
            break;
          case 'monthly':
            nextDate = DateTime(
              lastProcessed.year,
              lastProcessed.month + 1,
              lastProcessed.day,
            );
            break;
          default:
            continue;
        }

        while (nextDate.isBefore(now) || nextDate.isAtSameMomentAs(now)) {
          // Create new transaction
          final newTx = TransactionModel(
            amount: tx.amount,
            date: nextDate,
            categoryId: tx.categoryId,
            note: tx.note,
          );
          await DatabaseHelper.instance.createTransaction(newTx);
          
          // Update last processed date on the template transaction
          tx = tx.copyWith(lastProcessedDate: nextDate);
          await DatabaseHelper.instance.update('transactions', tx.toMap());
          
          addedAny = true;

          // Move to next occurrence
          switch (tx.recurrenceInterval) {
            case 'daily':
              nextDate = nextDate.add(const Duration(days: 1));
              break;
            case 'weekly':
              nextDate = nextDate.add(const Duration(days: 7));
              break;
            case 'monthly':
              nextDate = DateTime(
                nextDate.year,
                nextDate.month + 1,
                nextDate.day,
              );
              break;
          }
        }
      }

      if (addedAny) {
        await _fetchTransactionsCycle();
      }
    } catch (e) {
      debugPrint('Error checking recurring transactions: $e');
    }
  }

  // Future<void> _fetchTransactions() async {
  //   state = const AsyncValue.loading();
  //   try {
  //     final date = ref.read(selectedDateProvider);
  //
  //     final transactions = await DatabaseHelper.instance.getTransactionsByMonth(
  //       date,
  //     );
  //     state = AsyncValue.data(transactions);
  //   } catch (e, stack) {
  //     state = AsyncValue.error(e, stack);
  //   }
  // }

  Future<void> _fetchTransactionsCycle() async {
    state = const AsyncValue.loading();
    try {
      final startDay = ref.read(cycleStartDayProvider);
      final date = ref.read(selectedDateProvider);

      final transactions = await DatabaseHelper.instance.getTransactionsByCycle(
        startDay,
        date,
      );
      state = AsyncValue.data(transactions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.createTransaction(transaction);
    await PreferencesService().updateLastUpdated();
    await _fetchTransactionsCycle(); // Refresh list to update UI
  }

  // Call this when the user changes the month
  Future<void> refresh() async => await _fetchTransactionsCycle();

  Future<void> updateTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.update('transactions', transaction.toMap());
    await PreferencesService().updateLastUpdated();
    await _fetchTransactionsCycle(); // Refresh list to update UI
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.delete('transactions', id);
    await PreferencesService().updateLastUpdated();
    await _fetchTransactionsCycle(); // Refresh list to update UI
  }
}

// 2. THE FILTERED PROVIDER (This is the logic you asked for)
final currentCycleTransactionsProvider = Provider<List<TransactionModel>>((
  ref,
) {
  // A. Watch the full list of transactions
  final allTransactionsAsync = ref.watch(transactionsProvider);

  // B. Watch the cycle start day setting
  final startDay = ref.watch(cycleStartDayProvider);

  // C. Handle the AsyncValue state safely
  return allTransactionsAsync.when(
    loading: () => [], // Return empty while loading
    error: (_, __) => [], // Return empty on error
    data: (allTransactions) {
      if (allTransactions.isEmpty) return [];

      // D. Calculate the Date Range using your Utility
      final boundaries = BudgetCycleUtils.getCycleBoundaries(startDay);
      final startDate = boundaries['start']!;
      final endDate = boundaries['end']!;

      // E. Filter the list
      return allTransactions.where((tx) {
        // We use isAfter/isBefore with a slight buffer to include the exact boundary times
        return tx.date.isAfter(
              startDate.subtract(const Duration(seconds: 1)),
            ) &&
            tx.date.isBefore(endDate.add(const Duration(seconds: 1)));
      }).toList();
    },
  );
});

final transactionsProvider =
    StateNotifierProvider<
      TransactionsNotifier,
      AsyncValue<List<TransactionModel>>
    >((ref) {
      // Watch the date provider so we re-fetch if the user changes the month
      ref.watch(cycleStartDayProvider);
      return TransactionsNotifier(ref);
    });

// 4. Derived Providers (Selectors for Dashboard Logic)

// Calculate Total Budget (Sum of all category limits)
final totalBudgetProvider = Provider<double>((ref) {
  final categoriesState = ref.watch(categoriesProvider);
  return categoriesState.maybeWhen(
    data: (categories) =>
        categories.fold(0, (sum, item) => sum + item.monthlyLimit),
    orElse: () => 0.0,
  );
});

// Calculate Total Spent (Sum of all transactions in current view)
final totalSpentProvider = Provider<double>((ref) {
  final transactionsState = ref.watch(transactionsProvider);
  return transactionsState.maybeWhen(
    data: (transactions) =>
        transactions.fold(0, (sum, item) => sum + item.amount),
    orElse: () => 0.0,
  );
});

// Calculate Spending per Category (Map<CategoryId, Amount>)
final categorySpendingProvider = Provider<Map<int, double>>((ref) {
  final transactionsState = ref.watch(transactionsProvider);

  return transactionsState.maybeWhen(
    data: (transactions) {
      final Map<int, double> spending = {};
      for (var t in transactions) {
        spending[t.categoryId] = (spending[t.categoryId] ?? 0) + t.amount;
      }
      return spending;
    },
    orElse: () => {},
  );
});

// 1. Currency Notifier
class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('\$') {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final savedCurrency = await PreferencesService().getCurrency();
    state = savedCurrency;
  }

  Future<void> setCurrency(String newCurrency) async {
    state = newCurrency; // Update UI immediately
    await PreferencesService().setCurrency(newCurrency); // Save to disk
    await PreferencesService().updateLastUpdated();
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier();
});

// 2. Date Format Notifier
class DateFormatNotifier extends StateNotifier<String> {
  DateFormatNotifier() : super('MM/dd/yyyy') {
    _loadFormat();
  }

  Future<void> _loadFormat() async {
    final savedFormat = await PreferencesService().getDateFormat();
    state = savedFormat;
  }

  Future<void> setFormat(String newFormat) async {
    state = newFormat; // Update UI
    await PreferencesService().setDateFormat(newFormat); // Save to disk
    await PreferencesService().updateLastUpdated();
  }
}

final dateFormatProvider = StateNotifierProvider<DateFormatNotifier, String>((
  ref,
) {
  return DateFormatNotifier();
});

// 1. Theme Mode Provider
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await PreferencesService().getThemeMode();
    state = mode;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await PreferencesService().setThemeMode(mode);
    await PreferencesService().updateLastUpdated();
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

// 2. Primary Color Provider
class ColorSeedNotifier extends StateNotifier<Color> {
  ColorSeedNotifier() : super(const Color(0xFF4CAF50)) {
    // Default Green
    _loadColor();
  }

  Future<void> _loadColor() async {
    final colorInt = await PreferencesService().getColorSeed();
    state = Color(colorInt);
  }

  Future<void> setColor(Color color) async {
    state = color;
    await PreferencesService().setColorSeed(color.value);
    await PreferencesService().updateLastUpdated();
  }
}

final themeColorProvider = StateNotifierProvider<ColorSeedNotifier, Color>((
  ref,
) {
  return ColorSeedNotifier();
});

// 1. Define the Filter Types
enum TransactionFilter { all, daily, weekly, biweekly }

// 2. Create the Provider (Default to 'all' which shows the whole month)
final transactionFilterProvider = StateProvider<TransactionFilter>(
  (ref) => TransactionFilter.all,
);

// Add this to your budget_providers.dart
class CycleStartDayNotifier extends StateNotifier<int> {
  CycleStartDayNotifier() : super(1) {
    _load();
  }

  Future<void> _load() async {
    final day = await PreferencesService().getCycleStartDay();
    state = day;
  }

  Future<void> setDay(int day) async {
    state = day;
    await PreferencesService().setCycleStartDay(day);
    await PreferencesService().updateLastUpdated();
  }
}

// This holds the mapped budgets: { "food_id": 500.0, "rent_id": 1200.0 }
class CategoryBudgetsNotifier extends StateNotifier<Map<String, double>> {
  CategoryBudgetsNotifier() : super({});

  // Update a single category's budget
  void setBudget(String categoryId, double amount) {
    state = {...state, categoryId: amount};
    // TODO: In the future, save this to SharedPreferences or your local database here
  }

  // Calculate the total combined budget
  double get totalBudget {
    return state.values.fold(0.0, (sum, amount) => sum + amount);
  }
}

final categoryBudgetsProvider =
    StateNotifierProvider<CategoryBudgetsNotifier, Map<String, double>>((ref) {
      return CategoryBudgetsNotifier();
    });
