import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. MUST IMPORT THIS
import 'package:intl/intl.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';
import '../providers/budget_providers.dart';
import 'add_category_screen.dart';
import 'add_transaction_screen.dart'; // 2. MUST IMPORT YOUR PROVIDERS

// 3. Change StatelessWidget to ConsumerWidget
class CategoryDetailScreen extends ConsumerWidget {
  final CategoryModel category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  // 4. Add "WidgetRef ref" to the build parameters
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color,
        foregroundColor: Colors.white,
        actions: [
          // EDIT CATEGORY BUTTON
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // We'll pass the current category to the AddCategoryScreen to edit it
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddCategoryScreen(categoryToEdit: category),
                ),
              );
            },
          ),
          // DELETE BUTTON
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(category, ref),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Transaction History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TransactionModel>>(
              future: DatabaseHelper.instance.getTransactionsByCategory(
                category.id!,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No transactions."));
                }

                final transactions = snapshot.data!;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];

                    // 5. WRAP WITH DISMISSIBLE FOR DELETE
                    return Dismissible(
                      key: Key(tx.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      // CONFIRM DELETE DIALOG (Optional but safer)
                      confirmDismiss: (direction) async {
                        return await _showDeleteConfirmation(context);
                      },
                      onDismissed: (direction) {
                        // THIS SHOULD NOW WORK
                        ref
                            .read(transactionsProvider.notifier)
                            .deleteTransaction(tx.id!);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Transaction deleted')),
                        );
                      },
                      child: ListTile(
                        leading: Icon(category.icon, color: category.color),
                        title: Text(tx.note ?? 'Expense'),
                        subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                        trailing: Text(
                          '-\$${tx.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            // Allows sheet to expand with keyboard
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) =>
                                AddTransactionScreen(transactionToEdit: tx),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets & Dialogs ---

  Widget _buildHeader(CategoryModel category, WidgetRef ref) {
    final spendingByCategory = ref.watch(categorySpendingProvider);
    final spent = spendingByCategory[category.id] ?? 0.0;
    final double remaining = category.monthlyLimit - spent;

    return Container(
      padding: const EdgeInsets.all(20),
      color: category.color.withOpacity(0.1),
      child: Center(
        child: Column(
          children: [
            Icon(category.icon, size: 40, color: category.color),
            const SizedBox(height: 8),
            Text(
              "Budget: \$${category.monthlyLimit.toStringAsFixed(0)} ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: category.color,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " Spent: \$${spent.toStringAsFixed(0)}   ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  " Remaining:  \$${remaining.toStringAsFixed(0)} ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: remaining <= 0 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Category?"),
        content: const Text(
          "This will delete all transactions in this category.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Use the ID from the category object
              ref
                  .read(categoriesProvider.notifier)
                  .deleteCategory(category.id!);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back to Dashboard
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

Future<bool?> _showDeleteConfirmation(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Transaction?"),
      content: const Text("This action cannot be undone."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("CANCEL"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("DELETE", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
