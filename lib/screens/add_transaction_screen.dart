import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import '../models/transaction_model.dart';
import '../providers/budget_providers.dart';
import 'package:budget_manager/l10n/app_localizations.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel? transactionToEdit; 
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

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;
      _amountController.text = tx.amount.toString();
      _noteController.text = tx.note ?? '';
      _selectedDate = tx.date;
      _selectedCategoryId = tx.categoryId;
    }
  }

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

  Future<void> _submitData(AppLocalizations l10n) async {
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
        ref
            .read(transactionsProvider.notifier)
            .updateTransaction(newTransaction);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.transactionUpdatedMessage)));
      } else {
        ref.read(transactionsProvider.notifier).addTransaction(newTransaction);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.transactionAddedMessage)));
      }

      Navigator.of(context).pop();
    } else if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectCategoryError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesState = ref.watch(categoriesProvider);
    final currency = ref.watch(currencyProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.transactionToEdit != null
                  ? l10n.editTransactionTitle
                  : l10n.addTransactionTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.amountLabel,
                prefixText: currency,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _amountController.clear();
                  },
                  icon: const Icon(Icons.backspace_outlined),
                ),
              ),

              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterAmountError;
                }
                if (value.contains('+') ||
                    value.contains('-') ||
                    value.contains('*') ||
                    value.contains('/')) {
                  try {
                    Parser p = Parser();
                    Expression exp = p.parse(value);
                    ContextModel cm = ContextModel();
                    double eval = exp.evaluate(EvaluationType.REAL, cm);
                    _amountController.text = eval.toString();
                    return null;
                  } catch (e) {
                    return l10n.validNumberError;
                  }
                }
                if (double.tryParse(value) == null) {
                  return l10n.validNumberError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            categoriesState.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
              data: (categories) {
                if (categories.isEmpty) {
                  return Text(
                    l10n.noCategoriesWarning,
                  );
                }
                return DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: l10n.categoryLabel,
                    border: const OutlineInputBorder(),
                  ),
                  value: _selectedCategoryId,
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

            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.dateLabel} ${DateFormat.yMMMd().format(_selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    l10n.chooseDateAction,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: l10n.noteLabel,
                icon: const Icon(Icons.comment),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => _submitData(l10n),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.transactionToEdit != null
                    ? l10n.updateTransactionAction
                    : l10n.addTransactionAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
