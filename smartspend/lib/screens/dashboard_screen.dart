import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartSpend'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.person_outline, color: Colors.black54),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionSheet(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ListView(
          children: [
            Text(
              _monthLabel(DateTime.now()),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Balance',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              _currency(finance.balance),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Income',
                    amount: _currency(finance.totalIncome),
                    subtitle: 'This month',
                    icon: Icons.trending_up,
                    background: const Color(0xFFE6F8F3),
                    iconColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: 'Expenses',
                    amount: _currency(finance.totalExpenses),
                    subtitle: 'This month',
                    icon: Icons.trending_down,
                    background: const Color(0xFFFDECEF),
                    iconColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SummaryCard(
              title: 'Savings Progress',
              amount: '${(finance.savingsProgress * 100).toStringAsFixed(0)}% Achieved',
              subtitle: 'Across all goals',
              icon: Icons.savings_outlined,
              background: const Color(0xFFEDEBFF),
              iconColor: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...finance.transactions.take(5).map(
                  (transaction) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TransactionTile(transaction: transaction),
                  ),
                ),
            if (finance.transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 42,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No transactions yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap the + button to add your first income or expense.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionSheet(),
    );
  }

  String _currency(double value) => '₱${value.toStringAsFixed(2)}';

  String _monthLabel(DateTime date) {
    final month = _monthNames[date.month - 1];
    return '$month ${date.year}';
  }
}

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
