import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: const AssetImage('assets/images/profile.png'),
              backgroundColor: cs.surfaceContainerHighest,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Abdul rahman', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('abu@gmail.com', style: textTheme.bodySmall),
                ],
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: const [
              _InfoTile(title: 'Member since', value: '2025'),
              _InfoTile(title: 'Orders', value: '3 completed'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text('Notifications'),
                subtitle: Text('Promotions and order updates'),
                trailing: Icon(Icons.chevron_right),
              ),
              Divider(height: 0),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Security'),
                subtitle: Text('Password & login info'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Support & FAQ'),
                subtitle: Text('Care tips, returns, and contact'),
                trailing: Icon(Icons.chevron_right),
              ),
              Divider(height: 0),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined),
                title: Text('Privacy'),
                subtitle: Text('How we handle your data (demo)'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: FilledButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
