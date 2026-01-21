import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/budget_providers.dart';
import '../models/category_model.dart';
import 'add_category_screen.dart';
import 'add_transaction_screen.dart';
import 'category_detail_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch Data
    final totalBudget = ref.watch(totalBudgetProvider);
    final totalSpent = ref.watch(totalSpentProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final spendingByCategory = ref.watch(categorySpendingProvider);
    final currentDate = ref.watch(selectedDateProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        title: Text('Budget ${DateFormat('MMM yyyy').format(currentDate)}'),
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. The Major Graph (Pie Chart) ---
              SizedBox(
                height: 250,
                child: _buildPieChart(totalBudget, totalSpent),
              ),
              const SizedBox(height: 20),

              // --- 2. Summary Cards ---
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Budget',
                      totalBudget,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard('Spent', totalSpent, Colors.red),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard(
                      'Left',
                      totalBudget - totalSpent,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- 3. Category List Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Category Breakdown",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddCategoryScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text("Add Category"),
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
                    return const Center(child: Text("No categories found."));
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final spent = spendingByCategory[category.id] ?? 0.0;
                      return _CategoryProgressItem(
                        category: category,
                        spent: spent,
                      );
                    },
                  );
                },
              ),
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
        label: const Text("Add Expense"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildPieChart(double totalBudget, double totalSpent) {
    if (totalBudget == 0)
      return const Center(child: Text("Set a budget to see charts"));

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

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(0)}',
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

  const _CategoryProgressItem({required this.category, required this.spent});

  @override
  Widget build(BuildContext context) {
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
                      child: Icon(Icons.category, color: category.color),
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
                          '${(progress * 100).toStringAsFixed(0)}% used',
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
                      '\$${spent.toStringAsFixed(0)} / \$${category.monthlyLimit.toStringAsFixed(0)}',
                    ),
                    Text(
                      '\$${moneyLeft.toStringAsFixed(0)} left',
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
