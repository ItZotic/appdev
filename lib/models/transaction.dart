import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class FinanceTransaction {
  FinanceTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.account,
    this.notes,
  });

  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final String account;
  final String? notes;

  IconData get icon {
    switch (category) {
      case 'Food & Dining':
        return Icons.restaurant_outlined;
      case 'Transportation':
        return Icons.directions_bus_outlined;
      case 'Entertainment':
        return Icons.celebration_outlined;
      case 'Savings':
        return Icons.savings_outlined;
      case 'Salary':
        return Icons.payments_outlined;
      default:
        return Icons.attach_money_outlined;
    }
  }

  Color colorFor(TransactionType type, BuildContext context) {
    return type == TransactionType.income
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;
  }
}
