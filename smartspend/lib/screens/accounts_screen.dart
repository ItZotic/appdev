import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<FinanceProvider>().accounts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    'Total Net Worth',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₱${accounts.values.fold<double>(0, (sum, value) => sum + value).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Across ${accounts.length} accounts',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Accounts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.15,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: accounts.length + 1,
                itemBuilder: (context, index) {
                  if (index == accounts.length) {
                    return _AddAccountCard(onTap: () {});
                  }
                  final entry = accounts.entries.elementAt(index);
                  return _AccountCard(
                    name: entry.key,
                    balance: entry.value,
                    color: _cardColor(index),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.account_balance_wallet_outlined)),
                    title: Text('Added new bank account'),
                    subtitle: Text('2 days ago'),
                  ),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.swap_horiz_outlined)),
                    title: Text('Transferred ₱2,000 to savings'),
                    subtitle: Text('Last week'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _cardColor(int index) {
    const colors = [
      Color(0xFF5B61F6),
      Color(0xFF2BC4A3),
      Color(0xFF4C4F87),
      Color(0xFFFB6F92),
    ];
    return colors[index % colors.length];
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.name,
    required this.balance,
    required this.color,
  });

  final String name;
  final double balance;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white),
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            '₱${balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _AddAccountCard extends StatelessWidget {
  const _AddAccountCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.add, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              'Add New Account',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
