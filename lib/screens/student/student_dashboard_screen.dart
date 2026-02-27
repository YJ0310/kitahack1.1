import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

// ─── Temp Chat Data ───────────────────────────────────────────────────────────
class _ChatMsg {
  final String sender, text;
  final bool isMe;
  final DateTime time;
  _ChatMsg({
    required this.sender,
    required this.text,
    required this.isMe,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  late List<Map<String, dynamic>> _aiInsights;
  bool _loading = true;

  // AI Command
  final _aiCmdCtrl = TextEditingController();
  bool _aiCmdLoading = false;
  String? _aiCmdResult;

  // ── Temp Chat ──
  bool _chatOpen = false;
  final List<_ChatMsg> _messages = [
    _ChatMsg(
      sender: 'Sarah Lee',
      text: 'Hey! Are we meeting before Kitahack?',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    _ChatMsg(
      sender: 'Ahmad',
      text: 'Yeah, let\'s sync at 3pm today 👍',
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    _ChatMsg(
      sender: 'John Tan',
      text: 'I\'ll be there. Sharing the slides now.',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  void _sendMsg() {
    final txt = _msgCtrl.text.trim();
    if (txt.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(sender: 'You', text: txt, isMe: true));
      _msgCtrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _aiCmdCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _aiInsights = [];
    _fetchFromBackend();
  }

  /// Fetch live data from backend.
  Future<void> _fetchFromBackend() async {
    final api = ApiService();
    try {
      final insightData = await api.getInsights();
      if (insightData['insights'] != null) {
        final raw = insightData['insights'];
        if (raw is List && raw.isNotEmpty) {
          _aiInsights = raw.map<Map<String, dynamic>>((i) {
            return {
              'title': i['title'] ?? 'AI Insight',
              'content': i['content'] ?? i.toString(),
              'icon': Icons.auto_awesome_rounded,
              'color': AppTheme.primaryColor,
              'actionText': 'View',
            };
          }).toList();
        }
      }
    } catch (_) {}

    try {
      final events = await api.getEvents(upcoming: true);
      _upcomingEvents
        ..clear()
        ..addAll(events.take(3).map((e) {
              return <String, dynamic>{
                'title': e.title,
                'month': e.month,
                'day': e.day,
                'time': e.eventDate != null
                    ? '${e.eventDate!.hour}:${e.eventDate!.minute.toString().padLeft(2, '0')}'
                    : '',
                'location': e.location,
                'teamRequired': e.type == 'Competition',
                'category': e.type,
              };
            }));
    } catch (_) {}

    try {
      final matches = await api.getMyMatches();
      _myTeams
        ..clear()
        ..addAll(matches.take(3).map((m) {
              return <String, dynamic>{
                'name': 'Match: ${m.postId.substring(0, 8)}',
                'members': 2,
                'event': m.matchType,
                'status': m.matchStatus,
              };
            }));
    } catch (_) {}

    try {
      final candidates = await api.smartSearch('suggested connections');
      _suggestedUsers
        ..clear()
        ..addAll(candidates.take(3).map((c) {
              final m = Map<String, dynamic>.from(c);
              return <String, dynamic>{
                'name': m['name'] ?? 'User',
                'faculty': m['faculty'] ?? m['major'] ?? '',
                'skills': List<String>.from(m['skills'] ?? m['tags'] ?? []),
                'matchScore': ((m['score'] ?? 0) * 100).toInt(),
                'online': true,
              };
            }));
    } catch (_) {}

    // Fetch AI-recommended events
    try {
      final recs = await api.recommendEvents();
      _recommendedEvents
        ..clear()
        ..addAll(recs.take(4).map((r) {
          final m = Map<String, dynamic>.from(r);
          return <String, dynamic>{
            'title': m['title'] ?? m['eventTitle'] ?? 'Event',
            'reason': m['reason'] ?? m['explanation'] ?? 'Matches your profile',
            'category': m['type'] ?? m['category'] ?? 'Event',
            'date': m['date'] ?? '',
            'location': m['location'] ?? '',
            'score': m['score'] ?? m['relevanceScore'] ?? 0,
          };
        }));
    } catch (_) {}

    if (mounted) setState(() => _loading = false);
  }

  /// Execute an AI command with high permissions (Jarvis mode)
  Future<void> _runAiCommand() async {
    final prompt = _aiCmdCtrl.text.trim();
    if (prompt.isEmpty) return;
    setState(() { _aiCmdLoading = true; _aiCmdResult = null; });
    try {
      final result = await ApiService().aiCommand(prompt);
      final desc = result['description'] ?? 'Done';
      final executed = result['executed'] == true;
      final action = result['action'] ?? '';
      setState(() {
        _aiCmdResult = executed ? '✅ $desc' : '💡 $desc';
        _aiCmdLoading = false;
      });
      if (executed) {
        _aiCmdCtrl.clear();
        // Handle navigation action
        if (action == 'navigate' && result['data'] != null && mounted) {
          final path = result['data']['path'] ?? '/student';
          context.go(path);
        } else {
          _fetchFromBackend(); // Refresh data
        }
      }
    } catch (e) {
      setState(() {
        _aiCmdResult = '❌ Failed: $e';
        _aiCmdLoading = false;
      });
    }
  }

  // --- Data (loaded from API) ---
  final List<Map<String, dynamic>> _upcomingEvents = [];
  final List<Map<String, dynamic>> _myTeams = [];
  final List<Map<String, dynamic>> _suggestedUsers = [];
  final List<Map<String, dynamic>> _recommendedEvents = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: _ChatFab(
        open: _chatOpen,
        onTap: () => setState(() => _chatOpen = !_chatOpen),
      ).animate().fadeIn(delay: 600.ms),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Welcome Banner ---
                _WelcomeBanner(
                  isDark: isDark,
                  userName: AuthService().displayName?.split(' ').first ?? 'User',
                  eventCount: _upcomingEvents.length,
                  teamCount: _myTeams.length,
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 28),

                // --- AI Executive Summary (right after greeting) ---
                _SectionHeader(
                  title: 'AI Executive Summary',
                  icon: Icons.auto_awesome_rounded,
                  iconColor: AppTheme.accentPurple,
                ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
                const SizedBox(height: 12),
                if (_loading)
                  _SkeletonCard(isDark: isDark, height: 120)
                else if (_aiInsights.isEmpty)
                  _EmptyState(isDark: isDark, icon: Icons.auto_awesome_rounded, message: 'AI is analyzing your profile...', actionLabel: 'Refresh', onAction: _fetchFromBackend)
                else
                  _AIInsightsList(insights: _aiInsights),
                const SizedBox(height: 28),

                // --- AI Command Prompt Area ---
                _AiCommandBox(
                  controller: _aiCmdCtrl,
                  loading: _aiCmdLoading,
                  result: _aiCmdResult,
                  isDark: isDark,
                  onSubmit: _runAiCommand,
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
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
                            if (_loading)
                              ...[for (var i = 0; i < 2; i++) Padding(padding: const EdgeInsets.only(bottom: 12), child: _SkeletonCard(isDark: isDark, height: 90))]
                            else if (_upcomingEvents.isEmpty)
                              _EmptyState(isDark: isDark, icon: Icons.event_rounded, message: 'No upcoming events', actionLabel: 'Browse Events', onAction: () => context.go('/student/events'))
                            else
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
                            if (_loading)
                              ...[for (var i = 0; i < 2; i++) Padding(padding: const EdgeInsets.only(bottom: 12), child: _SkeletonCard(isDark: isDark, height: 80))]
                            else if (_myTeams.isEmpty)
                              _EmptyState(isDark: isDark, icon: Icons.group_add_rounded, message: 'No teams yet', actionLabel: 'Create Team', onAction: () => context.go('/student/teams'))
                            else
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
                      if (_loading)
                        ...[for (var i = 0; i < 2; i++) Padding(padding: const EdgeInsets.only(bottom: 12), child: _SkeletonCard(isDark: isDark, height: 90))]
                      else if (_upcomingEvents.isEmpty)
                        _EmptyState(isDark: isDark, icon: Icons.event_rounded, message: 'No upcoming events', actionLabel: 'Browse Events', onAction: () => context.go('/student/events'))
                      else
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
                      if (_loading)
                        ...[for (var i = 0; i < 2; i++) Padding(padding: const EdgeInsets.only(bottom: 12), child: _SkeletonCard(isDark: isDark, height: 80))]
                      else if (_myTeams.isEmpty)
                        _EmptyState(isDark: isDark, icon: Icons.group_add_rounded, message: 'No teams yet', actionLabel: 'Create Team', onAction: () => context.go('/student/teams'))
                      else
                        ..._myTeams.map(
                          (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _TeamCard(team: t, isDark: isDark),
                          ),
                        ),
                    ],
                  ).animate().fadeIn(delay: 250.ms, duration: 500.ms),

                const SizedBox(height: 28),
                // --- AI Recommended Events ---
                _SectionHeader(
                  title: 'Recommended For You',
                  icon: Icons.auto_awesome_rounded,
                  iconColor: const Color(0xFF8B5CF6),
                  actionText: 'View All',
                  onAction: () => context.go('/student/events'),
                ).animate().fadeIn(delay: 275.ms, duration: 400.ms),
                const SizedBox(height: 12),
                if (_loading)
                  SizedBox(
                    height: 150,
                    child: Row(children: [for (var i = 0; i < 3; i++) Expanded(child: Padding(padding: EdgeInsets.only(right: i < 2 ? 12 : 0), child: _SkeletonCard(isDark: isDark, height: 150)))]),
                  )
                else if (_recommendedEvents.isEmpty)
                  _EmptyState(isDark: isDark, icon: Icons.recommend_rounded, message: 'No recommendations yet — complete your profile for better matches', actionLabel: 'Browse Events', onAction: () => context.go('/student/events'))
                else
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recommendedEvents.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final rec = _recommendedEvents[i];
                        return _RecommendedEventCard(rec: rec, isDark: isDark);
                      },
                    ),
                  ).animate().fadeIn(delay: 280.ms, duration: 500.ms),
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
                if (_loading)
                  SizedBox(
                    height: 120,
                    child: Row(children: [for (var i = 0; i < 4; i++) Expanded(child: Padding(padding: EdgeInsets.only(right: i < 3 ? 12 : 0), child: _SkeletonCard(isDark: isDark, height: 120)))]),
                  )
                else if (_suggestedUsers.isEmpty)
                  _EmptyState(isDark: isDark, icon: Icons.person_search_rounded, message: 'No suggestions yet — add skills and interests to your profile')
                else
                  _SuggestedConnectionsGrid(
                    users: _suggestedUsers,
                    isDark: isDark,
                    isWide: isWide,
                  ).animate().fadeIn(delay: 350.ms, duration: 500.ms),
                const SizedBox(height: 80),
              ],
            ),
          ),
          // ── Temp Chat Panel ──
          if (_chatOpen)
            _ChatPanel(
              messages: _messages,
              msgCtrl: _msgCtrl,
              scrollCtrl: _scrollCtrl,
              isDark: isDark,
              onClose: () => setState(() => _chatOpen = false),
              onSend: _sendMsg,
            ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05, end: 0),
        ],
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
  final String userName;
  final int eventCount;
  final int teamCount;
  const _WelcomeBanner({required this.isDark, this.userName = 'User', this.eventCount = 0, this.teamCount = 0});

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
                'Good morning, $userName! ☕',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have $eventCount upcoming events and $teamCount team invitations pending.\nGrab a teh ais and start connecting!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
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

// ─────────────────────────────────────────────────────────
// Temp Chat FAB
// ─────────────────────────────────────────────────────────
class _ChatFab extends StatelessWidget {
  final bool open;
  final VoidCallback onTap;
  const _ChatFab({required this.open, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: open ? Colors.grey[800] : AppTheme.primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              open ? Icons.close_rounded : Icons.chat_bubble_rounded,
              color: Colors.white,
              size: 22,
            ),
            if (!open)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Temp Chat Panel
// ─────────────────────────────────────────────────────────
class _ChatPanel extends StatelessWidget {
  final List<_ChatMsg> messages;
  final TextEditingController msgCtrl;
  final ScrollController scrollCtrl;
  final bool isDark;
  final VoidCallback onClose;
  final VoidCallback onSend;
  const _ChatPanel({
    required this.messages,
    required this.msgCtrl,
    required this.scrollCtrl,
    required this.isDark,
    required this.onClose,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final tc = isDark ? Colors.white : AppTheme.textPrimaryColor;
    final sc = isDark
        ? Colors.white60
        : AppTheme.primaryColor.withValues(alpha: 0.55);

    return Positioned(
      right: 16,
      bottom: 16,
      child: Container(
        width: 320,
        height: 420,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.07),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_rounded,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team Chat',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: tc,
                          ),
                        ),
                        Text(
                          'Temporary · expires after 48 hours',
                          style: TextStyle(fontSize: 10, color: sc),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Icon(Icons.close_rounded, size: 18, color: sc),
                  ),
                ],
              ),
            ),
            // Messages
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (ctx, i) {
                  final msg = messages[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: msg.isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!msg.isMe) ...[
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppTheme.secondaryColor,
                            child: Text(
                              msg.sender[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Column(
                            crossAxisAlignment: msg.isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (!msg.isMe)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    msg.sender,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: sc,
                                    ),
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: msg.isMe
                                      ? AppTheme.primaryColor
                                      : (isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.08,
                                              )
                                            : Colors.black.withValues(
                                                alpha: 0.06,
                                              )),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(14),
                                    topRight: const Radius.circular(14),
                                    bottomLeft: Radius.circular(
                                      msg.isMe ? 14 : 4,
                                    ),
                                    bottomRight: Radius.circular(
                                      msg.isMe ? 4 : 14,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  msg.text,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: msg.isMe ? Colors.white : tc,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Input
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.07)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgCtrl,
                      style: TextStyle(fontSize: 13, color: tc),
                      onSubmitted: (_) => onSend(),
                      decoration: InputDecoration(
                        hintText: 'Message…',
                        hintStyle: TextStyle(fontSize: 13, color: sc),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onSend,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── AI Recommended Event Card ───────────────────────────────────────────────
class _RecommendedEventCard extends StatelessWidget {
  final Map<String, dynamic> rec;
  final bool isDark;

  const _RecommendedEventCard({required this.rec, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final tc = isDark ? Colors.white : const Color(0xFF0F172A);
    final sc = isDark ? Colors.white60 : const Color(0xFF64748B);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec['title'] ?? '',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tc),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rec['reason'] ?? 'Recommended based on your profile',
            style: TextStyle(fontSize: 11, color: sc),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              if ((rec['category'] ?? '').toString().isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    rec['category'] ?? '',
                    style: const TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                  ),
                ),
              const Spacer(),
              if ((rec['date'] ?? '').toString().isNotEmpty)
                Text(rec['date'] ?? '', style: TextStyle(fontSize: 10, color: sc)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── AI Command Box ─────────────────────────────────────
class _AiCommandBox extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final String? result;
  final bool isDark;
  final VoidCallback onSubmit;

  const _AiCommandBox({
    required this.controller,
    required this.loading,
    required this.result,
    required this.isDark,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final border = isDark ? Colors.white10 : Colors.black12;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentPurple.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentPurple.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: AppTheme.accentPurple),
              const SizedBox(width: 8),
              Text(
                'AI Assistant',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'High Access',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.accentPurple),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'e.g. "Add suitable tags for me", "Suggest events"...',
                    hintStyle: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
                    filled: true,
                    fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.accentPurple, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    isDense: true,
                  ),
                  onFieldSubmitted: (_) => onSubmit(),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  icon: loading
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.auto_awesome, size: 16),
                  label: Text(loading ? 'Running...' : 'Ask AI', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.accentPurple.withValues(alpha: 0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, size: 16, color: AppTheme.accentPurple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result!,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Skeleton Loading Card ──────────────────────────────
class _SkeletonCard extends StatelessWidget {
  final bool isDark;
  final double height;

  const _SkeletonCard({required this.isDark, required this.height});

  @override
  Widget build(BuildContext context) {
    final base = isDark ? const Color(0xFF2A2A3A) : const Color(0xFFE8E8E8);
    final highlight = isDark ? const Color(0xFF3A3A4A) : const Color(0xFFF5F5F5);
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [base, highlight, base],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat())
     .shimmer(duration: 1200.ms, color: highlight.withValues(alpha: 0.3));
  }
}

// ─── Empty State Widget ─────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyState({
    required this.isDark,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final sc = isDark ? Colors.white38 : Colors.black38;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: sc),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: sc, height: 1.4),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.08),
              ),
              child: Text(actionLabel!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }
}