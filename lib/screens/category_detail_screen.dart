import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';
import '../providers/budget_providers.dart';
import 'add_category_screen.dart';
import 'add_transaction_screen.dart';
import 'package:budget_manager/l10n/app_localizations.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final CategoryModel category;


  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = ref.watch(selectedDateProvider);
    final startDay = ref.watch(cycleStartDayProvider);
    final l10n = AppLocalizations.of(context)!;
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddCategoryScreen(categoryToEdit: category),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ref, l10n),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(category, ref, l10n, currency),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.transactionHistoryLabel,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TransactionModel>>(
              future: DatabaseHelper.instance.getTransactionsByCategory(
                category.id!,startDay,currentMonth,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(l10n.noTransactionsMessage));
                }

                final transactions = snapshot.data!;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];

                    return Dismissible(
                      key: Key(tx.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await _showDeleteConfirmation(context, l10n);
                      },
                      onDismissed: (direction) {
                        ref
                            .read(transactionsProvider.notifier)
                            .deleteTransaction(tx.id!);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.transactionDeletedMessage)),
                        );
                      },
                      child: ListTile(
                        leading: Icon(category.icon, color: category.color),
                        title: Text(tx.note ?? l10n.expenseSubtitle),
                        subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                        trailing: Text(
                          '-$currency${tx.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
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

  Widget _buildHeader(CategoryModel category, WidgetRef ref, AppLocalizations l10n, String currency) {
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
              "${l10n.budgetLabel}: $currency${category.monthlyLimit.toStringAsFixed(0)} ",
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
                  " ${l10n.spentPrefix} $currency${spent.toStringAsFixed(0)}   ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  " ${l10n.remainingLabel}  $currency${remaining.toStringAsFixed(0)} ",
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

  void _confirmDelete(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCategoryTitle),
        content: Text(
          l10n.deleteCategoryMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelAction),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(categoriesProvider.notifier)
                  .deleteCategory(category.id!);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.deleteAction, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTransactionTitle),
        content: Text(l10n.deleteTransactionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelAction),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteAction, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
