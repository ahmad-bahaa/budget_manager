import 'package:budget_manager/models/transaction_model.dart';
import 'package:budget_manager/screens/settings_screen.dart';
import 'package:budget_manager/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../providers/budget_providers.dart';
import '../models/category_model.dart';
import 'add_category_screen.dart';
import 'add_transaction_screen.dart';
import 'all_transactions_screen.dart';
import 'category_detail_screen.dart';
import 'package:budget_manager/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {

// 1. Create unique keys for the 3 items we want to highlight
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _expensesKey = GlobalKey();
  final GlobalKey _addCategoryeKey = GlobalKey();
  final GlobalKey _budget = GlobalKey();



  @override
  void initState() {
    super.initState();
    // 2. Check if we should show the hints after the screen builds

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowHints();
    });
  }
  Future<void> _checkAndShowHints() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenHints = prefs.getBool('has_seen_dashboard_hints') ?? false;

    if (!hasSeenHints) {
      if (!mounted) return;

      // NEW v5 Syntax: Start the showcase without needing context
      ShowcaseView.get().startShowCase([
        _settingsKey,
        _budget,
        _addCategoryeKey,
        _expensesKey,

      ]);

      // Save so it never shows again
      await prefs.setBool('has_seen_dashboard_hints', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // NEW: Watch the filtered list directly
    final currentTransactions = ref.watch(currentCycleTransactionsProvider);
    // 2. Recalculate Totals based on this new list
    final totalSpent = currentTransactions.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    // 1. Watch Data
    final totalBudget = ref.watch(totalBudgetProvider);
    // final totalSpent = ref.watch(totalSpentProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = ref.watch(categoriesProvider).value ?? []; // GET CATEGORIES
    final spendingByCategory = ref.watch(categorySpendingProvider);
    final currentDate = ref.watch(selectedDateProvider);
    final currency = ref.watch(currencyProvider);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final startDay = ref.watch(cycleStartDayProvider);
    final boundaries = BudgetCycleUtils.getCycleBoundaries(startDay);
    final rangeText =
        "${DateFormat('MMM d').format(boundaries['start']!)} - ${DateFormat('MMM d').format(boundaries['end']!)}";

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.budgetOverview, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text(
                rangeText, // Dynamic range based on your Payday
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              // Date Picker logic to change month
              final picked = await showDatePicker(
                context: context,
                initialDate: currentDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                ref.read(selectedDateProvider.notifier).state = picked;
              }
            },
          ),
          Showcase(
            key: _settingsKey,
            title: l10n.settings,
            description: 'Tap to open settings and change your preferences such as custom monthly cycle and Currency',
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. The Major Graph (Pie Chart) ---
              // SizedBox(
              //   height: 250,
              //   child: _buildPieChart(totalBudget, totalSpent),
              // ),
              // const SizedBox(height: 20),
              Showcase(
                key: _budget,
                title: l10n.budgetOverview,
                description: 'here to track total budget that been set when you add categories',
                child: SizedBox(
                  height: 250,
                  child: _buildAdvancedPieChart(
                    context,
                    totalBudget,
                    totalSpent,
                    currentTransactions,
                    categories
                  ),
                ),
              ),
              Center(child: _buildLegend(context, totalBudget, totalSpent, currentTransactions, categories, currency)),
              const SizedBox(height: 20),
              // --- 2. Summary Cards ---
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      l10n.budgetLabel,
                      totalBudget,
                      Colors.blue,
                      currency,
                      theme.cardColor,
                      isDarkMode,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Showcase(
                      key: _expensesKey,
                      title: l10n.expenseSubtitle,
                      description: 'Click here to see all your Expenses',
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AllTransactionsScreen(),
                            ),
                          );
                        },
                        child: _buildSummaryCard(
                          l10n.spentLabel,
                          totalSpent,
                          Colors.red,
                          currency,
                          theme.cardColor,
                          isDarkMode,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard(
                      l10n.leftLabel,
                      totalBudget - totalSpent,
                      Colors.green,
                      currency,
                      theme.cardColor,
                      isDarkMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- 3. Category List Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                    Text(
                      l10n.categoryBreakdownLabel,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  Showcase(
                    key: _addCategoryeKey,
                    title: l10n.addCategoryTitle,
                    description: 'Click here to add a new category',

                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddCategoryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      label: Text(l10n.addCategoryAction),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // --- 4. Category List ---
              categoriesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error: $err'),
                data: (categories) {
                  if (categories.isEmpty) {
                    return Center(child: Text(l10n.noCategoriesMessage));
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final spent = spendingByCategory[category.id] ?? 0.0;
                      return _CategoryProgressItem(
                        category: category,
                        spent: spent,
                        currency: currency,
                        color: theme.cardColor,
                        isDarkMode: isDarkMode,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      // FAB to Add Transaction (Stubbed for now)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allows sheet to expand with keyboard
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const AddTransactionScreen(),
          );
        },
        label: Text(l10n.addExpense),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildPieChart(BuildContext context, double totalBudget, double totalSpent) {
    final l10n = AppLocalizations.of(context)!;
    if (totalBudget == 0) {
      return Center(child: Text(l10n.setBudgetHint));
    }

    final remaining = (totalBudget - totalSpent).clamp(0.0, totalBudget);

    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: Colors.redAccent,
            value: totalSpent,
            title: '${((totalSpent / totalBudget) * 100).toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          PieChartSectionData(
            color: Colors.greenAccent,
            value: remaining,
            title: '',
            radius: 50,
          ),
        ],
      ),
    );
  }

  // Update your method signature to pass in the transactions
  Widget _buildAdvancedPieChart(
    BuildContext context,
    double totalBudget,
    double totalSpent,
    List<TransactionModel> currentTransactions,
      List<CategoryModel> categories,

  ) {
    final l10n = AppLocalizations.of(context)!;
    if (totalBudget == 0) {
      return Center(child: Text(l10n.setBudgetHint));
    }
    // 1. Calculate remaining budget
    final remaining = (totalBudget - totalSpent).clamp(0.0, totalBudget);
    // 2. Group transactions by Category ID
    Map<String, double> categoryTotals = {};
    for (var tx in currentTransactions) {
      if (categoryTotals.containsKey(tx.categoryId.toString())) {
        categoryTotals[tx.categoryId.toString()] =
            categoryTotals[tx.categoryId.toString()]! + tx.amount ;
      } else {
        categoryTotals[tx.categoryId.toString()] = tx.amount;
      }
    }
    // A palette of nice colors for the slices
    final List<Color> sectionColors = categories.map((category) => category.color).toList();

    // 3. Build the dynamic slices
    List<PieChartSectionData> chartSections = [];
    int colorIndex = 0;

    categoryTotals.forEach((categoryId, amount) {
      // Only show a slice if the amount is greater than 0
      if (amount > 0) {
        chartSections.add(
          PieChartSectionData(
            // color: categories[id].color,
            color: sectionColors[colorIndex % sectionColors.length],
            // Cycle through colors
            value: amount,
            title: '${((amount / totalBudget) * 100).toStringAsFixed(0)}%' ,
            // Keep it blank to avoid text overlapping on small slices
            radius: 50,
          ),
        );
        colorIndex++;
      }
    });

    // 4. Add the "Remaining Budget" slice at the end (Green)
    if (remaining > 0) {
      chartSections.add(
        PieChartSectionData(
          color: Colors.greenAccent.withOpacity(0.8),
          value: remaining,
          title: '${(100 - (totalSpent / totalBudget) * 100).toStringAsFixed(0)}%' ,
          radius: 50,
        ),
      );
    }

    // 5. Return the rendered chart
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        // Adds a sleek small gap between the different categories
        centerSpaceRadius: 40,
        sections: chartSections,
      ),
    );
  }

  // 1. The Main Legend Builder
  Widget _buildLegend(
      BuildContext context,
      double totalBudget,
      double totalSpent,
      List<TransactionModel> currentTransactions,
      List<CategoryModel> categories,
      String currencySymbol,
      ) {
    final l10n = AppLocalizations.of(context)!;
    if (totalBudget == 0 || currentTransactions.isEmpty) return const SizedBox();
    
    List<Widget> legendItems = [];

    if (totalSpent > 0) {
      legendItems.add(
          _buildLegendIndicator(Colors.redAccent, l10n.totalSpent, totalSpent / totalBudget * 100 , currencySymbol)
      );
    }
    // Add the "Remaining" indicator if there is money left
    final remaining = (totalBudget - totalSpent).clamp(0.0, totalBudget);
    if (remaining > 0) {
      legendItems.add(
          _buildLegendIndicator(Colors.greenAccent, l10n.remaining, remaining / totalBudget * 100 , currencySymbol)
      );
    }

    // Wrap automatically wraps items to the next line if they run out of horizontal space
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 12, // Horizontal space between items
        runSpacing: 8, // Vertical space between lines
        alignment: WrapAlignment.center,
        children: legendItems,
      ),
    );
  }

// 2. The Individual Indicator UI
  Widget _buildLegendIndicator(Color color, String name, double amount, String currency) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$name (%${amount.toStringAsFixed(0)})',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    Color color,
    String currency,
    Color ThemeColor,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDarkMode
            ? [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 10)]
            : [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '$currency${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProgressItem extends StatelessWidget {
  final CategoryModel category;
  final double spent;
  final String currency;
  final Color color;
  final bool isDarkMode;

  const _CategoryProgressItem({
    required this.category,
    required this.spent,
    required this.currency,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double progress = (category.monthlyLimit == 0)
        ? 0
        : (spent / category.monthlyLimit).clamp(0.0, 1.0);
    final double moneyLeft = category.monthlyLimit - spent;

    return GestureDetector(
      onTap: () {
        // Navigate to Detail Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailScreen(category: category),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: category.color.withOpacity(0.2),
                      child: Icon(category.icon, color: category.color),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}% ${l10n.used}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$currency${spent.toStringAsFixed(0)} / $currency${category.monthlyLimit.toStringAsFixed(0)}',
                    ),
                    Text(
                      '$currency${moneyLeft.toStringAsFixed(0)} ${l10n.left}',
                      style: TextStyle(
                        fontSize: 12,
                        color: moneyLeft < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: category.color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
