import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SchoolShell extends StatelessWidget {
  final Widget child;

  const SchoolShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(title: const Text('Teh Ais - School Portal')),
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
          decoration: BoxDecoration(color: Colors.green.shade100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.school_rounded, size: 48, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                'School Portal',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.green.shade800),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard_rounded),
          title: const Text('Dashboard'),
          onTap: () => context.go('/school'),
        ),
        ListTile(
          leading: const Icon(Icons.publish_rounded),
          title: const Text('Publish Content'),
          onTap: () => context.go('/school/publish'),
        ),
        ListTile(
          leading: const Icon(Icons.business_rounded),
          title: const Text('Enterprise Network'),
          onTap: () => context.go('/school/enterprise_network'),
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
