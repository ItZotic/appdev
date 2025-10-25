import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader(title: 'Account'),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Enable biometrics'),
            subtitle: const Text('Use fingerprint or face recognition'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.currency_exchange_outlined),
            title: const Text('Preferred currency'),
            subtitle: const Text('Philippine Peso (₱)'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Bill reminders'),
            subtitle: const Text('Daily at 9:00 AM'),
            onTap: () {},
          ),
          const Divider(),
          _SectionHeader(title: 'Security'),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Require PIN on launch'),
          ),
          SwitchListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Enable spending alerts'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.grey.shade600,
              letterSpacing: 1.1,
            ),
      ),
    );
  }
}
