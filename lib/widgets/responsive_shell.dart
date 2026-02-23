import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveShell extends StatelessWidget {
  final Widget child;

  const ResponsiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('Teh Ais')),
      drawer: isDesktop ? null : Drawer(child: _buildNavItems(context)),
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 250,
              color: Theme.of(context).cardColor,
              child: _buildNavItems(context),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildNavItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.hub_rounded, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                'Teh Ais Portal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI Tagging: Analyzing your work...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text(
              'Upload Work',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.dashboard_rounded),
          title: const Text('Dashboard'),
          onTap: () => context.go('/student'),
        ),
        ListTile(
          leading: const Icon(Icons.group_rounded),
          title: const Text('Teams & Pairing'),
          onTap: () => context.go('/student/team'),
        ),
        ListTile(
          leading: const Icon(Icons.event_rounded),
          title: const Text('Events'),
          onTap: () => context.go('/student/event'),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline_rounded),
          title: const Text('Profile & Tags'),
          onTap: () => context.go('/student/profile'),
        ),
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Icons.logout_rounded, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () => context.go('/'),
        ),
      ],
    );
  }
}
