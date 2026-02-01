import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import '../models/transaction_model.dart';
import '../providers/budget_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel? transactionToEdit; // If null, we are adding new
  const AddTransactionScreen({super.key, this.transactionToEdit});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int? _selectedCategoryId;

  // Cleanup controllers
  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill data if editing
    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;
      _amountController.text = tx.amount.toString();
      _noteController.text = tx.note ?? '';
      _selectedDate = tx.date;
      _selectedCategoryId = tx.categoryId;
    }
  }

  // --- Date Picker Logic ---
  Future<void> _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // --- Submit Logic ---
  Future<void> _submitData() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      final enteredAmount = double.parse(_amountController.text);
      final enteredNote = _noteController.text;

      final newTransaction = TransactionModel(
        id: widget.transactionToEdit?.id,
        amount: enteredAmount,
        date: _selectedDate,
        categoryId: _selectedCategoryId!,
        note: enteredNote.isEmpty ? null : enteredNote,
      );
      if (widget.transactionToEdit != null) {
        // EDIT MODE
        ref
            .read(transactionsProvider.notifier)
            .updateTransaction(newTransaction);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Transaction updated!')));
      } else {
        // ADD MODE
        ref.read(transactionsProvider.notifier).addTransaction(newTransaction);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Transaction added!')));
      }

      Navigator.of(context).pop();

      // // Save via Riverpod Notifier
      // await ref
      //     .read(transactionsProvider.notifier)
      //     .addTransaction(newTransaction);
      //
      // // Close the modal
      // Navigator.of(context).pop();
    } else if (_selectedCategoryId == null) {
      // Show error if no category selected
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch categories to populate dropdown
    final categoriesState = ref.watch(categoriesProvider);

    return Padding(
      // Handle keyboard covering text fields
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content height
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.transactionToEdit != null
                  ? 'Edit Transaction'
                  : 'New Expense',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 1. Amount Field
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _amountController.clear();
                  },
                  icon: Icon(Icons.backspace_outlined),
                ),
              ),

              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value!.contains('+') ||
                    value.contains('-') ||
                    value.contains('*') ||
                    value.contains('/')) {
                  // 1. Parse the expression
                  Parser p = Parser();
                  Expression exp = p.parse(value);

                  // 2. Evaluate the expression
                  ContextModel cm = ContextModel();
                  double eval = exp.evaluate(EvaluationType.REAL, cm);
                  _amountController.text = eval.toString();
                  return null;
                }
                if (value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 2. Category Dropdown
            categoriesState.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Error loading categories: $err'),
              data: (categories) {
                if (categories.isEmpty) {
                  return const Text(
                    "No categories found. Please add one first.",
                  );
                }
                return DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _selectedCategoryId,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: category.color, size: 16),
                          const SizedBox(width: 8),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // 3. Date Picker Row
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text(
                    'Choose Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            // 4. Note Field (Optional)
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (Optional)',
                icon: Icon(Icons.comment),
              ),
            ),
            const SizedBox(height: 24),

            // 5. Submit Button
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.transactionToEdit != null
                    ? 'Update Transaction'
                    : 'Add Transaction',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
