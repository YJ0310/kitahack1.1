import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

void _showPublishDialog(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1e1e1e) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.publish_rounded, color: Colors.teal, size: 20),
          const SizedBox(width: 8),
          Text(
            'Publish Opportunity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Opportunity title...',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark ? Colors.white70 : AppTheme.textPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  ['Internship', 'Workshop', 'Research', 'Event', 'Scholarship']
                      .map(
                        (s) => FilterChip(
                          label: Text(s),
                          selected: false,
                          onSelected: (_) {},
                          selectedColor: Colors.teal.withValues(alpha: 0.2),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opportunity published!')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: const Text('Publish'),
        ),
      ],
    ),
  );
}

void _showPartnersDialog(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final partners = [
    {'name': 'TechCorp Malaysia', 'type': 'Enterprise', 'status': 'Active'},
    {'name': 'FinBank Asia', 'type': 'Finance', 'status': 'Active'},
    {
      'name': 'GreenTech Solutions',
      'type': 'Sustainability',
      'status': 'Pending',
    },
    {'name': 'NexGen Labs', 'type': 'Research', 'status': 'Active'},
    {'name': 'DataFlow Inc', 'type': 'Technology', 'status': 'Pending'},
  ];
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1e1e1e) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.business_rounded, color: Colors.teal, size: 20),
          const SizedBox(width: 8),
          Text(
            'Partner Network',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: partners
              .map(
                (p) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.withValues(alpha: 0.15),
                    child: Text(
                      (p['name'] as String)[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  title: Text(
                    p['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                  ),
                  subtitle: Text(
                    p['type'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: p['status'] == 'Active'
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      p['status'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: p['status'] == 'Active'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class SchoolDashboardScreen extends StatelessWidget {
  const SchoolDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeBanner(isDark: isDark).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 20),
            _StatsRow(
              isWide: isWide,
            ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
            const SizedBox(height: 24),
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _RecentPubs(
                          isDark: isDark,
                        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _Partners(
                          isDark: isDark,
                        ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _RecentPubs(
                        isDark: isDark,
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                      const SizedBox(height: 16),
                      _Partners(
                        isDark: isDark,
                      ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
                    ],
                  ),
            const SizedBox(height: 24),
            _Insights(
              isDark: isDark,
              isWide: isWide,
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  final bool isDark;
  const _WelcomeBanner({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.teal, Color(0xFF00897B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'School Admin Dashboard 🎓',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Welcome back, University of Malaya. Your network is thriving.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _showPublishDialog(context),
                icon: const Icon(Icons.publish_rounded, size: 16),
                label: const Text('Publish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => _showPartnersDialog(context),
                icon: const Icon(Icons.business_rounded, size: 16),
                label: const Text('Partners'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final bool isWide;
  const _StatsRow({required this.isWide});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stats = [
      {
        'icon': Icons.school_rounded,
        'label': 'Students',
        'value': '12,450',
        'color': Colors.teal,
      },
      {
        'icon': Icons.campaign_rounded,
        'label': 'Published',
        'value': '86',
        'color': Colors.blue,
      },
      {
        'icon': Icons.business_rounded,
        'label': 'Partners',
        'value': '24',
        'color': Colors.orange,
      },
      {
        'icon': Icons.event_rounded,
        'label': 'Active Events',
        'value': '15',
        'color': Colors.purple,
      },
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isWide ? 4 : 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: isWide ? 2.0 : 1.8,
      children: stats
          .map(
            (s) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppTheme.backgroundColor.withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (s['color'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      s['icon'] as IconData,
                      size: 16,
                      color: s['color'] as Color,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    s['value'] as String,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    s['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppTheme.primaryColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _RecentPubs extends StatelessWidget {
  final bool isDark;
  const _RecentPubs({required this.isDark});
  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        'title': 'Kitahack 2026 Registration Open!',
        'type': 'Event',
        'date': 'Feb 20',
        'color': Colors.orange,
      },
      {
        'title': 'Scholarship Applications Q2',
        'type': 'Announcement',
        'date': 'Feb 18',
        'color': Colors.blue,
      },
      {
        'title': 'Flutter Workshop Series',
        'type': 'Workshop',
        'date': 'Feb 15',
        'color': Colors.purple,
      },
      {
        'title': 'Career Fair 2026',
        'type': 'Event',
        'date': 'Feb 10',
        'color': Colors.green,
      },
    ];
    return _Card(
      isDark: isDark,
      title: 'Recent Publications',
      children: posts
          .map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (p['color'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.article_rounded,
                      size: 14,
                      color: p['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['title'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppTheme.textPrimaryColor,
                          ),
                        ),
                        Text(
                          '${p['type']} • ${p['date']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : AppTheme.primaryColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Partners extends StatelessWidget {
  final bool isDark;
  const _Partners({required this.isDark});
  @override
  Widget build(BuildContext context) {
    final partners = [
      {'name': 'TechCorp Malaysia', 'type': 'Technology', 'students': 42},
      {'name': 'FinanceHub', 'type': 'Finance', 'students': 28},
      {'name': 'GreenTech Solutions', 'type': 'Sustainability', 'students': 15},
      {'name': 'MedTech Asia', 'type': 'Healthcare', 'students': 22},
    ];
    return _Card(
      isDark: isDark,
      title: 'Enterprise Partners',
      children: partners
          .map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : AppTheme.backgroundColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.teal.withValues(alpha: 0.15),
                      child: Text(
                        (p['name'] as String)[0],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['name'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                          Text(
                            '${p['type']} • ${p['students']} students',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Insights extends StatelessWidget {
  final bool isDark;
  final bool isWide;
  const _Insights({required this.isDark, required this.isWide});
  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'label': 'Avg. GPA',
        'value': '3.52',
        'icon': Icons.school_rounded,
        'color': Colors.green,
      },
      {
        'label': 'Active in Events',
        'value': '68%',
        'icon': Icons.event_rounded,
        'color': Colors.orange,
      },
      {
        'label': 'With Teams',
        'value': '1,230',
        'icon': Icons.groups_rounded,
        'color': Colors.blue,
      },
      {
        'label': 'Skills Tagged',
        'value': '45,200',
        'icon': Icons.tag_rounded,
        'color': Colors.purple,
      },
    ];
    return _Card(
      isDark: isDark,
      title: 'Student Insights',
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 4 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: isWide ? 2.2 : 1.6,
          children: items
              .map(
                (i) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : AppTheme.backgroundColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        i['icon'] as IconData,
                        size: 18,
                        color: i['color'] as Color,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        i['value'] as String,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                      Text(
                        i['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : AppTheme.primaryColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final bool isDark;
  final String title;
  final List<Widget> children;
  const _Card({
    required this.isDark,
    required this.title,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.backgroundColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
