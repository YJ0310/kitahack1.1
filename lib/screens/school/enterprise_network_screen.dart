import 'package:flutter/material.dart';

class EnterpriseNetworkScreen extends StatelessWidget {
  const EnterpriseNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enterprise Network',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            const Text('Partner companies looking for our talent.'),
            const SizedBox(height: 48),

            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: const [
                _CompanyCard(
                  name: 'TechCorp Malaysia',
                  focus: 'IT & Software',
                  openRoles: 5,
                ),
                _CompanyCard(
                  name: 'FinBank Asia',
                  focus: 'Finance & Banking',
                  openRoles: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final String name;
  final String focus;
  final int openRoles;

  const _CompanyCard({
    required this.name,
    required this.focus,
    required this.openRoles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.business, size: 36, color: Colors.blue),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(focus, style: const TextStyle(color: Colors.grey)),
        childrenPadding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$openRoles Open Roles',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OutlinedButton(onPressed: () {}, child: const Text('View Roles')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.email_outlined, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              const Text('Contact HR'),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
