import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/finance_provider.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _category = 'Food & Dining';
  String _account = 'Cash';
  TransactionType _type = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finance = context.read<FinanceProvider>();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: controller,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              ToggleButtons(
                borderRadius: BorderRadius.circular(20),
                isSelected: [
                  _type == TransactionType.expense,
                  _type == TransactionType.income,
                ],
                fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                selectedColor: Theme.of(context).colorScheme.primary,
                onPressed: (index) {
                  setState(() {
                    _type = index == 0
                        ? TransactionType.expense
                        : TransactionType.income;
                  });
                },
                constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('- Expense'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('+ Income'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                _formattedCurrency(_amountController.text),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter merchant or description',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₱',
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  'Food & Dining',
                  'Transportation',
                  'Entertainment',
                  'Education',
                  'Savings',
                  'Salary',
                ].map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                ).toList(),
                onChanged: (value) => setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _account,
                decoration: const InputDecoration(labelText: 'Account'),
                items: finance.accounts.keys
                    .map(
                      (account) => DropdownMenuItem(
                        value: account,
                        child: Text(account),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _account = value ?? _account),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(_formattedDate(_selectedDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final transaction = FinanceTransaction(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      description: _descriptionController.text.trim(),
                      amount: double.parse(_amountController.text.trim()),
                      category: _category,
                      date: _selectedDate,
                      type: _type,
                      account: _account,
                      notes: _notesController.text.trim().isEmpty
                          ? null
                          : _notesController.text.trim(),
                    );
                    finance.addTransaction(transaction);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(_type == TransactionType.expense
                    ? 'Add Expense'
                    : 'Add Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selected != null) {
      setState(() => _selectedDate = selected);
    }
  }

  String _formattedCurrency(String value) {
    final amount = double.tryParse(value);
    if (amount == null) return '₱0';
    return '₱${amount.toStringAsFixed(2)}';
  }

  String _formattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
