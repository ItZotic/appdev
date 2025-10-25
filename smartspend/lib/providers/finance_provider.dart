import 'dart:math';

import 'package:flutter/material.dart';

import '../models/budget.dart';
import '../models/goal.dart';
import '../models/transaction.dart';

class FinanceProvider extends ChangeNotifier {
  final List<FinanceTransaction> _transactions = [];
  final List<BudgetCategory> _budgets = [];
  final List<SavingsGoal> _goals = [];
  final Map<String, double> _accounts = {
    'Cash': 0,
    'Bank Account': 0,
    'Savings Account': 0,
  };

  List<FinanceTransaction> get transactions => List.unmodifiable(_transactions);
  List<BudgetCategory> get budgets => List.unmodifiable(_budgets);
  List<SavingsGoal> get goals => List.unmodifiable(_goals);
  Map<String, double> get accounts => Map.unmodifiable(_accounts);

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpenses;

  double get savingsProgress => _goals.isEmpty
      ? 0
      : _goals.map((g) => g.progress).reduce((a, b) => a + b) / _goals.length;

  void seedDemoData() {
    final now = DateTime.now();
    addTransaction(
      FinanceTransaction(
        id: _generateId(),
        description: 'Tech Corp Salary',
        amount: 25000,
        category: 'Salary',
        date: now.subtract(const Duration(days: 1)),
        type: TransactionType.income,
        account: 'Bank Account',
      ),
      notify: false,
    );
    addTransaction(
      FinanceTransaction(
        id: _generateId(),
        description: 'Whole Foods',
        amount: 850,
        category: 'Food & Dining',
        date: now,
        type: TransactionType.expense,
        account: 'Cash',
      ),
      notify: false,
    );
    addTransaction(
      FinanceTransaction(
        id: _generateId(),
        description: 'Gas Station',
        amount: 450.5,
        category: 'Transportation',
        date: now.subtract(const Duration(days: 2)),
        type: TransactionType.expense,
        account: 'Bank Account',
      ),
      notify: false,
    );

    _budgets.addAll([
      BudgetCategory(name: 'Food & Dining', limit: 10000, spent: 850),
      BudgetCategory(name: 'Transportation', limit: 6000, spent: 450.5),
      BudgetCategory(name: 'Entertainment', limit: 3000, spent: 0),
    ]);

    _goals.addAll([
      SavingsGoal(
        title: 'New Laptop',
        target: 60000,
        saved: 18000,
        deadline: now.add(const Duration(days: 120)),
      ),
      SavingsGoal(
        title: 'Travel Fund',
        target: 30000,
        saved: 9000,
        deadline: now.add(const Duration(days: 200)),
      ),
    ]);

    notifyListeners();
  }

  void addTransaction(FinanceTransaction transaction, {bool notify = true}) {
    _transactions.insert(0, transaction);
    _accounts.update(
      transaction.account,
      (value) => transaction.type == TransactionType.income
          ? value + transaction.amount
          : value - transaction.amount,
      ifAbsent: () => transaction.type == TransactionType.income
          ? transaction.amount
          : -transaction.amount,
    );

    final budget = _budgets.firstWhere(
      (b) => b.name == transaction.category,
      orElse: () => BudgetCategory(name: transaction.category, limit: 0, spent: 0),
    );

    if (!_budgets.contains(budget) && budget.limit == 0) {
      _budgets.add(budget);
    }

    if (transaction.type == TransactionType.expense) {
      budget.spent += transaction.amount;
    }

    if (notify) {
      notifyListeners();
    }
  }

  void updateGoalProgress(String title, double amount) {
    final goal = _goals.firstWhere((g) => g.title == title);
    goal.saved = (goal.saved + amount).clamp(0, goal.target);
    notifyListeners();
  }

  String _generateId() => Random().nextInt(1 << 32).toString();
}
