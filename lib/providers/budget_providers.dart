import 'package:budget_manager/services/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';

// 1. Current Date State (for filtering by month)
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// 2. Categories Provider (AsyncNotifier pattern)
class CategoriesNotifier
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  CategoriesNotifier() : super(const AsyncValue.loading()) {
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await DatabaseHelper.instance.getAllCategories();
      state = AsyncValue.data(categories);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    await DatabaseHelper.instance.createCategory(category);
    await _fetchCategories(); // Refresh list
  }

  Future<void> updateCategory(CategoryModel category) async {
    if (category.id == null) return;
    await DatabaseHelper.instance.update('categories', category.toMap());
    await _fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    await DatabaseHelper.instance.delete('categories', id);
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
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    state = const AsyncValue.loading();
    try {
      final date = ref.read(selectedDateProvider);
      final transactions = await DatabaseHelper.instance.getTransactionsByMonth(
        date,
      );
      state = AsyncValue.data(transactions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.createTransaction(transaction);
    await _fetchTransactions(); // Refresh list to update UI
  }

  // Call this when the user changes the month
  Future<void> refresh() async => await _fetchTransactions();

  Future<void> updateTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.update('transactions', transaction.toMap());

     await _fetchTransactions(); // Refresh list to update UI
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.delete('transactions', id);
    await _fetchTransactions(); // Refresh list to update UI
  }
}

final transactionsProvider =
    StateNotifierProvider<
      TransactionsNotifier,
      AsyncValue<List<TransactionModel>>
    >((ref) {
      // Watch the date provider so we re-fetch if the user changes the month
      ref.watch(selectedDateProvider);
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
  }
}

final dateFormatProvider = StateNotifierProvider<DateFormatNotifier, String>((ref) {
  return DateFormatNotifier();
});

