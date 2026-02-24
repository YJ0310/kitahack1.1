import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class EnterpriseDashboardScreen extends StatelessWidget {
  const EnterpriseDashboardScreen({super.key});

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
            // Welcome Banner
            _WelcomeBanner(isDark: isDark).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 20),
            // Stats Row
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isWide ? 4 : 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: isWide ? 2.0 : 1.8,
              children: const [
                _StatCard(
                  icon: Icons.people_rounded,
                  label: 'Total Candidates',
                  value: '2,847',
                  change: '+12%',
                  changeUp: true,
                  color: Colors.purple,
                ),
                _StatCard(
                  icon: Icons.send_rounded,
                  label: 'Invites Sent',
                  value: '156',
                  change: '+24',
                  changeUp: true,
                  color: Colors.blue,
                ),
                _StatCard(
                  icon: Icons.handshake_rounded,
                  label: 'Accepted',
                  value: '43',
                  change: '28%',
                  changeUp: true,
                  color: Colors.green,
                ),
                _StatCard(
                  icon: Icons.event_rounded,
                  label: 'Active Events',
                  value: '8',
                  change: '',
                  changeUp: true,
                  color: Colors.orange,
                ),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
            const SizedBox(height: 24),
            // Two-column: Pipeline + Recent Activity
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _PipelineSection(
                          isDark: isDark,
                        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _RecentActivity(
                          isDark: isDark,
                        ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _PipelineSection(
                        isDark: isDark,
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                      const SizedBox(height: 16),
                      _RecentActivity(
                        isDark: isDark,
                      ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
                    ],
                  ),
            const SizedBox(height: 24),
            // Top Candidates
            _TopCandidates(
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
          colors: [Colors.purple, Colors.deepPurple],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back, TechCorp 👋',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your talent pipeline is growing. 12 new candidates matched this week.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded, size: 16),
                label: const Text('Search Candidates'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.analytics_rounded, size: 16),
                label: const Text('View Reports'),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value, change;
  final bool changeUp;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    required this.changeUp,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const Spacer(),
              if (change.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    change,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : AppTheme.primaryColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _PipelineSection extends StatelessWidget {
  final bool isDark;
  const _PipelineSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pipeline = [
      {'name': 'Screening', 'count': 24, 'color': Colors.blue},
      {'name': 'Interview', 'count': 12, 'color': Colors.orange},
      {'name': 'Technical', 'count': 8, 'color': Colors.purple},
      {'name': 'Offer', 'count': 3, 'color': Colors.green},
    ];
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
            'Recruitment Pipeline',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 14),
          ...pipeline.map((p) {
            final count = p['count'] as int;
            final color = p['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p['name'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppTheme.primaryColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: count / 30,
                        minHeight: 6,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : AppTheme.backgroundColor.withValues(alpha: 0.5),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  final bool isDark;
  const _RecentActivity({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'icon': Icons.person_add_rounded,
        'text': 'New candidate: Sarah M.',
        'time': '2h ago',
        'color': Colors.blue,
      },
      {
        'icon': Icons.check_circle_rounded,
        'text': 'Alex Lee accepted invite',
        'time': '5h ago',
        'color': Colors.green,
      },
      {
        'icon': Icons.event_rounded,
        'text': 'Kitahack 2026 starts in 3 weeks',
        'time': '1d ago',
        'color': Colors.orange,
      },
      {
        'icon': Icons.star_rounded,
        'text': '3 new top matches found',
        'time': '2d ago',
        'color': Colors.purple,
      },
    ];
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
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 14),
          ...activities.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (a['color'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      a['icon'] as IconData,
                      size: 14,
                      color: a['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      a['text'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppTheme.primaryColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  Text(
                    a['time'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.3)
                          : AppTheme.primaryColor.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCandidates extends StatelessWidget {
  final bool isDark;
  final bool isWide;
  const _TopCandidates({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final candidates = [
      {
        'name': 'Alex Lee',
        'faculty': 'IT & Business',
        'match': 98,
        'tags': ['Python', 'Finance', 'Data'],
      },
      {
        'name': 'Sarah Rahman',
        'faculty': 'Computer Science',
        'match': 92,
        'tags': ['Flutter', 'Firebase', 'UI/UX'],
      },
      {
        'name': 'Wei Jun',
        'faculty': 'Engineering',
        'match': 87,
        'tags': ['IoT', 'Embedded', 'C++'],
      },
      {
        'name': 'Priya Nair',
        'faculty': 'Data Science',
        'match': 85,
        'tags': ['ML', 'Statistics', 'R'],
      },
    ];
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Top Candidates',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...candidates.map((c) {
            final tags = c['tags'] as List;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : AppTheme.backgroundColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.purple.withValues(alpha: 0.2),
                      child: Text(
                        (c['name'] as String)[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['name'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                          Text(
                            c['faculty'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 4,
                            children: tags
                                .map(
                                  (t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      t as String,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${c['match']}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Invite'),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
