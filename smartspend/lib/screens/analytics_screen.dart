import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/finance_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final expenseData = _buildCategoryData(finance);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: _AnalyticsSummaryCard(
                    title: 'Income',
                    amount: '₱${finance.totalIncome.toStringAsFixed(0)}',
                    icon: Icons.arrow_upward,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AnalyticsSummaryCard(
                    title: 'Expenses',
                    amount: '₱${finance.totalExpenses.toStringAsFixed(0)}',
                    icon: Icons.arrow_downward,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Expense Breakdown',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      DropdownButton<String>(
                        value: 'This month',
                        items: const [
                          DropdownMenuItem(
                            value: 'This month',
                            child: Text('This month'),
                          ),
                        ],
                        onChanged: (_) {},
                        underline: const SizedBox.shrink(),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          for (final entry in expenseData.entries)
                            PieChartSectionData(
                              value: entry.value,
                              color: _categoryColor(entry.key),
                              title: '${entry.value.toStringAsFixed(0)}%',
                              radius: 80,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                        sectionsSpace: 4,
                        centerSpaceRadius: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: expenseData.keys
                        .map(
                          (category) => _LegendChip(
                            color: _categoryColor(category),
                            label: '$category (${expenseData[category]!.toStringAsFixed(0)}%)',
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '6-Month Trend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 42),
                          ),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final months = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
                                if (value.toInt() < months.length) {
                                  return Text(months[value.toInt()]);
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 4,
                            dotData: const FlDotData(show: false),
                            spots: const [
                              FlSpot(0, 12),
                              FlSpot(1, 11),
                              FlSpot(2, 10),
                              FlSpot(3, 15),
                              FlSpot(4, 13),
                              FlSpot(5, 17),
                            ],
                          ),
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.redAccent,
                            barWidth: 4,
                            dotData: const FlDotData(show: false),
                            spots: const [
                              FlSpot(0, 9),
                              FlSpot(1, 12),
                              FlSpot(2, 11),
                              FlSpot(3, 14),
                              FlSpot(4, 12),
                              FlSpot(5, 13),
                            ],
                          ),
                        ],
                      ),
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

  Map<String, double> _buildCategoryData(FinanceProvider finance) {
    final totals = <String, double>{};
    final expenses = finance.transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    final totalAmount = expenses.fold<double>(0, (sum, t) => sum + t.amount);
    for (final transaction in expenses) {
      totals.update(transaction.category, (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount);
    }
    if (totalAmount == 0) {
      return {for (final entry in totals.entries) entry.key: 0};
    }
    return totals.map(
        (category, amount) => MapEntry(category, (amount / totalAmount) * 100));
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Food & Dining':
        return const Color(0xFF5B61F6);
      case 'Transportation':
        return const Color(0xFF2BC4A3);
      case 'Entertainment':
        return const Color(0xFFFB6F92);
      case 'Education':
        return const Color(0xFFFFA41B);
      default:
        return const Color(0xFF4C4F87);
    }
  }
}

class _AnalyticsSummaryCard extends StatelessWidget {
  const _AnalyticsSummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style:
                Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
