import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';

class CategoryDetailScreen extends StatelessWidget {
  final CategoryModel category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color,
        foregroundColor: Colors.white, // Text color
      ),
      body: Column(
        children: [
          // 1. Header Summary Card
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: category.color.withOpacity(0.2)),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Monthly Limit",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                Text(
                  "\$${category.monthlyLimit.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: category.color
                  ),
                ),
              ],
            ),
          ),

          // 2. Transactions List Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.history, color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  "Transaction History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 3. Dynamic List of Transactions
          Expanded(
            child: FutureBuilder<List<TransactionModel>>(
              // Fetch transactions specific to this category
              future: DatabaseHelper.instance.getTransactionsByCategory(category.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No transactions found for this category.'));
                }

                final transactions = snapshot.data!;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: category.color.withOpacity(0.2),
                        child: Icon(Icons.receipt, color: category.color, size: 20),
                      ),
                      title: Text(
                        tx.note != null && tx.note!.isNotEmpty
                            ? tx.note!
                            : 'Expense',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                      trailing: Text(
                        '-\$${tx.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
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
}