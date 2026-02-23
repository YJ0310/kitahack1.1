import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EnterpriseShell extends StatelessWidget {
  final Widget child;

  const EnterpriseShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('Enterprise Portal')),
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
          decoration: BoxDecoration(color: Colors.purple.shade50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.business_center_rounded,
                size: 48,
                color: Colors.purple,
              ),
              const SizedBox(height: 16),
              Text(
                'TechCorp Malaysia',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.purple.shade800),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard_rounded),
          title: const Text('Dashboard'),
          onTap: () => context.go('/enterprise'),
        ),
        ListTile(
          leading: const Icon(Icons.person_search_rounded),
          title: const Text('Candidate Search'),
          onTap: () => context.go('/enterprise/candidates'),
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
