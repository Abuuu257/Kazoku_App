import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'login_screen.dart';
import 'order_history_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.user;
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
              backgroundColor: cs.surfaceContainerHighest,
              // Display local image first, then backend URL, then default icon
              backgroundImage: user?.profileImageLocal != null
                  ? FileImage(user!.profileImageLocal!)
                  : (user?.fullProfileImageUrl != null
                      ? NetworkImage(user!.fullProfileImageUrl!) as ImageProvider
                      : null),
              child: (user?.profileImageLocal == null && user?.fullProfileImageUrl == null)
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(user?.name ?? 'Guest', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: textTheme.bodySmall),
                ],
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: cs.surfaceContainer,
          leading: const Icon(Icons.history),
          title: const Text('My Orders'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
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
            onPressed: () async {
              await context.read<AppState>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
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
