import 'package:budget_manager/providers/budget_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import your providers and models here

class BudgetSetupScreen extends ConsumerWidget {
  const BudgetSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the categories and the current budgets
    final categories = ref.watch(categoriesProvider).value ?? [];
    final categoryBudgets = ref.watch(categoryBudgetsProvider);
    final totalBudget = ref.read(categoryBudgetsProvider.notifier).totalBudget;
    final currency = ref.watch(
      currencyProvider,
    ); // Assuming you have this from earlier

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Budgets'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'DONE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. The Dynamic Header
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Planned Budget',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '$currency${totalBudget.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 2. The Interactive Category List
          Expanded(
            child: ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final category = categories[index];
                final currentAmount = categoryBudgets[category.id] ?? 0.0;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor:
                        Colors.grey.shade200, // Or use category.color
                    child: const Icon(
                      Icons.category,
                      color: Colors.black54,
                    ), // Or category.icon
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  // The smooth inline text field
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        prefixText: currency,
                        hintText: '0',
                        border: InputBorder
                            .none, // Removes the ugly box for a cleaner look
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      // Pre-fill if there's already a budget
                      controller:
                          TextEditingController(
                              text: currentAmount > 0
                                  ? currentAmount.toStringAsFixed(0)
                                  : '',
                            )
                            ..selection = TextSelection.collapsed(
                              offset: currentAmount > 0
                                  ? currentAmount.toStringAsFixed(0).length
                                  : 0,
                            ),

                      // Update Riverpod instantly as they type
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        ref
                            .read(categoryBudgetsProvider.notifier)
                            .setBudget(category.id as String, amount);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
