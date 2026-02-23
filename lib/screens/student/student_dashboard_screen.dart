import 'package:flutter/material.dart';
import 'dart:math';
import '../../theme/app_theme.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  late final List<Map<String, dynamic>> _aiInsights;

  @override
  void initState() {
    super.initState();
    _generateDynamicInsights();
  }

  void _generateDynamicInsights() {
    final allPossibleInsights = [
      {
        'title': 'New Team Request',
        'content':
            'Sarah from IT Faculty invited you to join "Fintech Hackathon".',
        'icon': Icons.group_add_rounded,
        'color': AppTheme.primaryColor,
        'actionText': 'Accept Request',
      },
      {
        'title': 'Strategic Event Alert',
        'content':
            'Data Science Workshop starts in 2 hours. Required to upgrade your "Python" tag to Mastered.',
        'icon': Icons.event_rounded,
        'color': AppTheme.secondaryColor,
        'actionText': 'Join Session',
      },
      {
        'title': 'Portfolio Tip',
        'content':
            'Add your latest "Machine Learning" project to boost visibility to matching teams by 40%.',
        'icon': Icons.insights_rounded,
        'color': AppTheme.accentOrange,
        'actionText': 'Upload Portfolio',
      },
      {
        'title': 'Network Opportunity',
        'content':
            '3 people from your "UI/UX Design" courses are looking for a backend developer.',
        'icon': Icons.connect_without_contact_rounded,
        'color': AppTheme.accentPink,
        'actionText': 'View Profiles',
      },
      {
        'title': 'Enterprise Match',
        'content':
            'FinBank Asia just posted an internship matching your "Data Analysis" tags (92% match).',
        'icon': Icons.business_center_rounded,
        'color': AppTheme.accentPurple,
        'actionText': 'Apply Now',
      },
    ];

    allPossibleInsights.shuffle();
    final insightCount = 3 + Random().nextInt(3); // 3, 4, or 5
    _aiInsights = allPossibleInsights.take(insightCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Alex!',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Here are your latest updates and actionable items.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppTheme.accentPurple,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Executive Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentPurple.withValues(alpha: 0.05),
                    AppTheme.primaryColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.accentPurple.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: _aiInsights.asMap().entries.map((entry) {
                  final index = entry.key;
                  final insight = entry.value;
                  return Column(
                    children: [
                      _AIActionRow(
                        title: insight['title'] as String,
                        content: insight['content'] as String,
                        icon: insight['icon'] as IconData,
                        color: insight['color'] as Color,
                        actionText: insight['actionText'] as String,
                      ),
                      if (index < _aiInsights.length - 1)
                        Divider(
                          height: 1,
                          color: AppTheme.accentPurple.withValues(alpha: 0.1),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AIActionRow extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;
  final String actionText;

  const _AIActionRow({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text(actionText),
          ),
        ],
      ),
    );
  }
}
