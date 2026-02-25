import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
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
        'actionText': 'Accept',
      },
      {
        'title': 'Strategic Event Alert',
        'content':
            'Data Science Workshop starts in 2 hours. Required to upgrade your "Python" tag.',
        'icon': Icons.event_rounded,
        'color': AppTheme.secondaryColor,
        'actionText': 'Join',
      },
      {
        'title': 'Enterprise Match',
        'content':
            'FinBank Asia posted an internship matching your "Data Analysis" tags (92% match).',
        'icon': Icons.business_center_rounded,
        'color': AppTheme.accentPurple,
        'actionText': 'Apply',
      },
    ];
    allPossibleInsights.shuffle();
    final insightCount = 2 + Random().nextInt(2);
    _aiInsights = allPossibleInsights.take(insightCount).toList();
  }

  // --- Data ---
  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'Kitahack 2026',
      'month': 'MAR',
      'day': '15',
      'time': '9:00 AM',
      'location': 'Main Hall',
      'teamRequired': true,
      'category': 'Hackathon',
    },
    {
      'title': 'Flutter Workshop',
      'month': 'MAR',
      'day': '18',
      'time': '2:00 PM',
      'location': 'Lab 3',
      'teamRequired': false,
      'category': 'Workshop',
    },
    {
      'title': 'Networking Mixer',
      'month': 'MAR',
      'day': '22',
      'time': '6:00 PM',
      'location': 'Cafeteria',
      'teamRequired': false,
      'category': 'Networking',
    },
  ];

  final List<Map<String, dynamic>> _myTeams = [
    {
      'name': 'Project Phoenix',
      'members': 4,
      'event': 'Kitahack 2026',
      'status': 'Active',
    },
    {'name': 'Study Buddies', 'members': 3, 'event': null, 'status': 'Casual'},
  ];

  final List<Map<String, dynamic>> _suggestedUsers = [
    {
      'name': 'Sarah Lee',
      'faculty': 'Computer Science',
      'skills': ['React', 'Node.js', 'UI/UX'],
      'matchScore': 92,
      'online': true,
    },
    {
      'name': 'John Tan',
      'faculty': 'Business',
      'skills': ['Marketing', 'Strategy', 'Finance'],
      'matchScore': 87,
      'online': false,
    },
    {
      'name': 'Maya Wong',
      'faculty': 'Design',
      'skills': ['Figma', 'Branding', 'Motion'],
      'matchScore': 85,
      'online': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Welcome Banner ---
            _WelcomeBanner(isDark: isDark).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 24),

            // --- Stats Row ---
            _StatsGrid(isWide: isWide)
                .animate()
                .fadeIn(delay: 100.ms, duration: 500.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 28),

            // --- AI Insights ---
            _SectionHeader(
              title: 'AI Executive Summary',
              icon: Icons.auto_awesome_rounded,
              iconColor: AppTheme.accentPurple,
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
            const SizedBox(height: 12),
            _AIInsightsList(
              insights: _aiInsights,
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
            const SizedBox(height: 28),

            // --- Events + Teams ---
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          title: 'Upcoming Events',
                          icon: Icons.calendar_today_rounded,
                          iconColor: AppTheme.primaryColor,
                          actionText: 'View All',
                          onAction: () => context.go('/student/events'),
                        ),
                        const SizedBox(height: 12),
                        ..._upcomingEvents.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _EventCard(event: e, isDark: isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          title: 'My Teams',
                          icon: Icons.groups_rounded,
                          iconColor: AppTheme.secondaryColor,
                          actionText: '+ New',
                          onAction: () => context.go('/student/teams'),
                        ),
                        const SizedBox(height: 12),
                        ..._myTeams.map(
                          (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _TeamCard(team: t, isDark: isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 250.ms, duration: 500.ms)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Upcoming Events',
                    icon: Icons.calendar_today_rounded,
                    iconColor: AppTheme.primaryColor,
                    actionText: 'View All',
                    onAction: () => context.go('/student/events'),
                  ),
                  const SizedBox(height: 12),
                  ..._upcomingEvents.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _EventCard(event: e, isDark: isDark),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(
                    title: 'My Teams',
                    icon: Icons.groups_rounded,
                    iconColor: AppTheme.secondaryColor,
                    actionText: '+ New',
                    onAction: () => context.go('/student/teams'),
                  ),
                  const SizedBox(height: 12),
                  ..._myTeams.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TeamCard(team: t, isDark: isDark),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 250.ms, duration: 500.ms),

            const SizedBox(height: 28),
            // --- Suggested Connections ---
            _SectionHeader(
              title: 'Suggested for You',
              icon: Icons.connect_without_contact_rounded,
              iconColor: AppTheme.accentPink,
              actionText: 'View All',
              onAction: () => _showSuggestedDialog(context),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
            const SizedBox(height: 12),
            _SuggestedConnectionsGrid(
              users: _suggestedUsers,
              isDark: isDark,
              isWide: isWide,
            ).animate().fadeIn(delay: 350.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }

  void _showSuggestedDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1e1e1e) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.connect_without_contact_rounded,
              color: AppTheme.accentPink,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Suggested Connections',
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
            children: _suggestedUsers
                .map(
                  (u) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        (u['name'] as String)[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    title: Text(
                      u['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                    subtitle: Text(
                      '${u['faculty']} • ${u['matchScore']}% match',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white54
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Connection request sent to ${u['name']}!',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Connect'),
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
}

// ─────────────────────────────────────────────────────────
// Welcome Banner
// ─────────────────────────────────────────────────────────
class _WelcomeBanner extends StatelessWidget {
  final bool isDark;
  const _WelcomeBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDarkColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Ahmad! ☕',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have 3 upcoming events and 2 team invitations pending.\nGrab a teh ais and start connecting!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _BannerButton(
                    label: 'Browse Events',
                    icon: Icons.calendar_today_rounded,
                    filled: true,
                    onTap: () => context.go('/student/events'),
                  ),
                  _BannerButton(
                    label: 'My Teams',
                    icon: Icons.group_rounded,
                    filled: false,
                    onTap: () => context.go('/student/teams'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _BannerButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
          border: filled
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: filled ? AppTheme.primaryDarkColor : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: filled ? AppTheme.primaryDarkColor : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Stats Grid
// ─────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final bool isWide;
  const _StatsGrid({required this.isWide});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'label': 'Events Joined',
        'value': '12',
        'trend': '+3 this month',
        'icon': Icons.calendar_today_rounded,
        'colors': [AppTheme.primaryColor, AppTheme.secondaryColor],
      },
      {
        'label': 'Teams',
        'value': '3',
        'trend': null,
        'icon': Icons.groups_rounded,
        'colors': [AppTheme.secondaryColor, AppTheme.backgroundColor],
      },
      {
        'label': 'Achievements',
        'value': '7',
        'trend': '+1 new',
        'icon': Icons.emoji_events_rounded,
        'colors': [AppTheme.primaryDarkColor, AppTheme.primaryColor],
      },
      {
        'label': 'Connections',
        'value': '45',
        'trend': '+8 this week',
        'icon': Icons.bolt_rounded,
        'colors': [AppTheme.backgroundColor, AppTheme.secondaryColor],
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isWide ? 1.4 : 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, i) => _StatCard(stat: stats[i]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Map<String, dynamic> stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = stat['colors'] as List<Color>;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.backgroundColor.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  stat['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : AppTheme.primaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  stat['icon'] as IconData,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat['value'] as String,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                ),
              ),
              if (stat['trend'] != null)
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      size: 13,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        stat['trend'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String? actionText;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
        ),
        if (actionText != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionText!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// AI Insights
// ─────────────────────────────────────────────────────────
class _AIInsightsList extends StatelessWidget {
  final List<Map<String, dynamic>> insights;
  const _AIInsightsList({required this.insights});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentPurple.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentPurple.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: insights.asMap().entries.map((entry) {
          final index = entry.key;
          final insight = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (insight['color'] as Color).withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        insight['icon'] as IconData,
                        color: insight['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            insight['content'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.7,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final actionLabel = insight['actionText'] as String;
                        final title = insight['title'] as String;
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to "$actionLabel" for "$title"?',
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
                                    SnackBar(
                                      content: Text(
                                        '$actionLabel action completed!',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: insight['color'] as Color,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(actionLabel),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: insight['color'] as Color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(insight['actionText'] as String),
                    ),
                  ],
                ),
              ),
              if (index < insights.length - 1)
                Divider(
                  height: 1,
                  color: AppTheme.accentPurple.withValues(alpha: 0.1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Event Card
// ─────────────────────────────────────────────────────────
class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final bool isDark;
  const _EventCard({required this.event, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date badge
          Container(
            width: 56,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event['month'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  event['day'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] as String,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppTheme.primaryColor.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event['time'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.location_on_rounded,
                      size: 12,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppTheme.primaryColor.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event['location'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Badge(
                      label: (event['teamRequired'] as bool)
                          ? 'Team Required'
                          : 'Solo Entry',
                      color: (event['teamRequired'] as bool)
                          ? AppTheme.primaryColor
                          : AppTheme.secondaryColor,
                    ),
                    const SizedBox(width: 6),
                    _Badge(
                      label: event['category'] as String,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppTheme.backgroundColor,
                      textColor: isDark
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppTheme.primaryDarkColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark
                ? Colors.white.withValues(alpha: 0.3)
                : AppTheme.primaryColor.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Team Card
// ─────────────────────────────────────────────────────────
class _TeamCard extends StatelessWidget {
  final Map<String, dynamic> team;
  final bool isDark;
  const _TeamCard({required this.team, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isActive = team['status'] == 'Active';

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${team['members']} members',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              _Badge(
                label: team['status'] as String,
                color: isActive
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.15),
                textColor: isActive ? Colors.green : Colors.grey,
              ),
            ],
          ),
          if (team['event'] != null) ...[
            Divider(
              height: 16,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppTheme.backgroundColor.withValues(alpha: 0.7),
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : AppTheme.primaryColor.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    team['event'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppTheme.primaryColor.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Suggested Connections Grid
// ─────────────────────────────────────────────────────────
class _SuggestedConnectionsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final bool isDark;
  final bool isWide;
  const _SuggestedConnectionsGrid({
    required this.users,
    required this.isDark,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 3 : 1,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isWide ? 1.7 : 3.5,
      ),
      itemCount: users.length,
      itemBuilder: (context, i) => _UserCard(user: users[i], isDark: isDark),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool isDark;
  const _UserCard({required this.user, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final skills = user['skills'] as List<String>;
    final online = user['online'] as bool;

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      (user['name'] as String).substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (online)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.black : Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                    Text(
                      user['faculty'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${user['matchScore']}% match',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.5)
                                : AppTheme.primaryColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryColor),
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                child: const Text('Connect'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: skills.take(3).map((s) => _Badge(label: s)).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Reusable Badge
// ─────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const _Badge({required this.label, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        color ??
        (isDark
            ? Colors.white.withValues(alpha: 0.1)
            : AppTheme.backgroundColor.withValues(alpha: 0.5));
    final fg =
        textColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.8)
            : AppTheme.primaryDarkColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
