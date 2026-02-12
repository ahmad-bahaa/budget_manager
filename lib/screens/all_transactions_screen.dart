import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/budget_providers.dart';
import '../models/category_model.dart';
import 'add_transaction_screen.dart';
import '../core/app_constants.dart';

class AllTransactionsScreen extends ConsumerWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final currentDate = ref.watch(selectedDateProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final currency = ref.watch(currencyProvider);
    final dateFormatPattern = ref.watch(dateFormatProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('History: ${DateFormat('MMMM').format(currentDate)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
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
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                'No transactions found for this month.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];

              final category = categoriesAsync.asData?.value.firstWhere(
                (c) => c.id == tx.categoryId,
                orElse: () => CategoryModel(
                  id: -1,
                  name: 'Unknown',
                  monthlyLimit: 0,
                  colorHex: '0xFF9E9E9E',
                  iconCode: Icons.help_outline.codePoint,
                ),
              );

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
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text(AppConstants.deleteTransactionTitle),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text(AppConstants.cancelAction),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            AppConstants.deleteAction,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  ref
                      .read(transactionsProvider.notifier)
                      .deleteTransaction(tx.id!);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        category?.color.withOpacity(0.1) ?? Colors.grey[200],
                    child: Icon(
                      category?.icon ?? Icons.help,
                      color: category?.color ?? Colors.grey,
                    ),
                  ),
                  title: Text(
                    tx.note != null && tx.note!.isNotEmpty
                        ? tx.note!
                        : category?.name ?? AppConstants.expenseSubtitle,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(DateFormat(dateFormatPattern).format(tx.date)),
                  trailing: Text(
                    '-$currency${tx.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
                      builder: (_) => AddTransactionScreen(transactionToEdit: tx),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
