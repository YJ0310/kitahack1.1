import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

// ─── Mock Data ────────────────────────────────────────────────────────────────
class _TeamMember {
  final String name;
  final String role;
  final bool isLead;
  final bool online;
  _TeamMember(this.name, this.role, {this.isLead = false, this.online = true});
}

class _Room {
  final String name;
  final int members;
  final int maxMembers;
  final List<String> skills;
  final String event;
  final int matchPercent;
  _Room(
    this.name,
    this.members,
    this.maxMembers,
    this.skills,
    this.event,
    this.matchPercent,
  );
}

final _myTeamMembers = [
  _TeamMember('Ahmad Raza', 'Full-Stack Developer', isLead: true),
  _TeamMember('Sarah Lee', 'UI/UX Designer'),
  _TeamMember('John Tan', 'Data Scientist', online: false),
];

final _suggestedRooms = [
  _Room('Team Alpha', 2, 4, ['React', 'Node.js', 'AWS'], 'Kitahack 2026', 92),
  _Room(
    'Innovators',
    3,
    5,
    ['Python', 'AI/ML', 'Flask'],
    'AI Case Competition',
    87,
  ),
  _Room(
    'Code Warriors',
    1,
    4,
    ['Flutter', 'Firebase', 'Dart'],
    'Kitahack 2026',
    85,
  ),
  _Room(
    'DataMinds',
    2,
    3,
    ['Pandas', 'SQL', 'Tableau'],
    'Data Science Workshop',
    78,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────
class StudentTeamScreen extends StatefulWidget {
  const StudentTeamScreen({super.key});

  @override
  State<StudentTeamScreen> createState() => _StudentTeamScreenState();
}

class _StudentTeamScreenState extends State<StudentTeamScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Room State
  String _inviteCode = 'KH-8492-AC';
  bool _isAIPoolActive = false;

  // Group Chat State
  bool _isTeamFormed = false;
  bool _isCreatingGroup = false;
  int _countdownSeconds = 180;
  String _groupLinkError = '';
  final _linkController = TextEditingController();
  Timer? _timer;

  // Create Room Dialog
  bool _showCreateRoom = false;
  final _roomNameCtrl = TextEditingController();
  int _roomMaxMembers = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _linkController.dispose();
    _roomNameCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCreatingGroup = true;
      _countdownSeconds = 180;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_countdownSeconds > 0 && _isCreatingGroup) {
        setState(() => _countdownSeconds--);
      } else {
        t.cancel();
        if (_countdownSeconds == 0) {
          setState(() {
            _isCreatingGroup = false;
            _groupLinkError = 'Time expired. Someone else can attempt.';
          });
        }
      }
    });
  }

  void _validateLink() {
    final link = _linkController.text.trim();
    final isValid = RegExp(
      r'^(https?:\/\/)?(chat\.whatsapp\.com|t\.me|discord\.gg)\/.*$',
    ).hasMatch(link);
    if (isValid) {
      setState(() {
        _isCreatingGroup = false;
        _groupLinkError = '';
      });
      _timer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Group chat link saved!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      setState(
        () => _groupLinkError =
            'Invalid link. Use WhatsApp, Telegram, or Discord.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teams & Pairing',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your teams, rooms, and find the perfect teammates',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                    ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
                    const SizedBox(height: 20),
                    // Tab Bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : AppTheme.backgroundColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryDarkColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: 'My Room'),
                          Tab(text: 'Find Rooms'),
                          Tab(text: 'My Team'),
                        ],
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMyRoomTab(isDark),
                    _buildFindRoomsTab(isDark),
                    _buildMyTeamTab(isDark),
                  ],
                ),
              ),
            ],
          ),
          // Create Room Dialog
          if (_showCreateRoom)
            _CreateRoomDialog(
              isDark: isDark,
              nameCtrl: _roomNameCtrl,
              maxMembers: _roomMaxMembers,
              onMaxChanged: (v) => setState(() => _roomMaxMembers = v),
              onClose: () => setState(() => _showCreateRoom = false),
              onCreate: () {
                setState(() {
                  _showCreateRoom = false;
                  _inviteCode =
                      'KH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}-AC';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Room "${_roomNameCtrl.text.trim().isNotEmpty ? _roomNameCtrl.text.trim() : 'My Room'}" created!',
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ─── My Room Tab ──────────────────────────────────────────────────────────
  Widget _buildMyRoomTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Info Card
          _GlassCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryDarkColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.meeting_room_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Phoenix Room',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                          Text(
                            'Kitahack 2026 • 3/4 members',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(label: 'Open', color: Colors.green),
                  ],
                ),
                const SizedBox(height: 16),
                // Invite Code
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppTheme.backgroundColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.vpn_key_rounded,
                        size: 14,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Invite Code: ',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : AppTheme.primaryColor.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        _inviteCode,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          color: isDark ? Colors.white : AppTheme.primaryColor,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: _inviteCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Code copied!'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.copy_rounded,
                                size: 12,
                                color: AppTheme.primaryColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Copy',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Members
                _SectionLabel(
                  'Room Members',
                  Icons.group_rounded,
                  AppTheme.secondaryColor,
                ),
                const SizedBox(height: 10),
                ..._myTeamMembers.map(
                  (m) => _MemberTile(member: m, isDark: isDark),
                ),
                const SizedBox(height: 10),
                // Invite slot
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppTheme.backgroundColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : AppTheme.backgroundColor.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : AppTheme.primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : AppTheme.primaryColor.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Waiting for 1 more member…',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : AppTheme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // AI Pool Toggle
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: _isAIPoolActive
                        ? LinearGradient(
                            colors: [
                              AppTheme.accentPurple.withValues(alpha: 0.1),
                              AppTheme.primaryColor.withValues(alpha: 0.1),
                            ],
                          )
                        : null,
                    color: _isAIPoolActive
                        ? null
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : AppTheme.backgroundColor.withValues(
                                  alpha: 0.2,
                                )),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isAIPoolActive
                          ? AppTheme.accentPurple.withValues(alpha: 0.3)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppTheme.backgroundColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 18,
                        color: _isAIPoolActive
                            ? AppTheme.accentPurple
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.5,
                                    )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Matching Pool',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _isAIPoolActive
                                    ? AppTheme.accentPurple
                                    : (isDark
                                          ? Colors.white
                                          : AppTheme.textPrimaryColor),
                              ),
                            ),
                            Text(
                              _isAIPoolActive
                                  ? 'Scanning for compatible teammates…'
                                  : 'Join the AI pool to get auto-matched',
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
                      Switch(
                        value: _isAIPoolActive,
                        onChanged: (v) => setState(() => _isAIPoolActive = v),
                        activeColor: AppTheme.accentPurple,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
          const SizedBox(height: 16),
          // Create another room
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _showCreateRoom = true),
              icon: const Icon(Icons.add_circle_outlined, size: 16),
              label: const Text('Create New Room'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppTheme.primaryColor.withValues(alpha: 0.4),
                ),
                foregroundColor: isDark
                    ? Colors.white70
                    : AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        ],
      ),
    );
  }

  // ─── Find Rooms Tab ───────────────────────────────────────────────────────
  Widget _buildFindRoomsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            'AI-Suggested Rooms',
            Icons.auto_awesome_rounded,
            AppTheme.accentPurple,
          ),
          const SizedBox(height: 4),
          Text(
            'Based on your skills and interests',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.4)
                  : AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 14),
          ..._suggestedRooms.asMap().entries.map(
            (e) => _SuggestedRoomCard(
              room: e.value,
              isDark: isDark,
              delay: e.key * 80,
              onJoin: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Join request sent to ${e.value.name}!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── My Team Tab ──────────────────────────────────────────────────────────
  Widget _buildMyTeamTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team Status Banner
          _GlassCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.secondaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Phoenix',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                          Text(
                            _isTeamFormed
                                ? 'Team formed • Ready to go!'
                                : 'Room active • Waiting for members',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isTeamFormed
                                  ? Colors.green
                                  : (isDark
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : AppTheme.primaryColor.withValues(
                                            alpha: 0.6,
                                          )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(
                      label: _isTeamFormed ? 'Formed' : 'Building',
                      color: _isTeamFormed ? Colors.green : Colors.amber,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action button
                if (!_isTeamFormed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _isTeamFormed = true),
                      icon: const Icon(Icons.lock_rounded, size: 16),
                      label: const Text('Lock Team (Convert Room to Team)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
          const SizedBox(height: 16),
          // Members
          _SectionLabel(
            'Team Members',
            Icons.people_rounded,
            AppTheme.secondaryColor,
          ),
          const SizedBox(height: 10),
          ..._myTeamMembers.map((m) => _MemberTile(member: m, isDark: isDark)),
          const SizedBox(height: 16),
          // Group Chat Section
          _GlassCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(
                  'Group Chat',
                  Icons.chat_bubble_rounded,
                  AppTheme.accentPurple,
                ),
                const SizedBox(height: 12),
                if (!_isTeamFormed)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Lock the team first to enable group chat creation.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.amber.shade100
                                  : Colors.amber.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (!_isCreatingGroup && _groupLinkError.isEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _startCountdown,
                      icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                      label: const Text('I\'ll Create the Group Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                else if (_isCreatingGroup) ...[
                  // Timer
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.accentPurple.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_rounded,
                          size: 18,
                          color: AppTheme.accentPurple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(_countdownSeconds ~/ 60).toString().padLeft(2, '0')}:${(_countdownSeconds % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: AppTheme.accentPurple,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Paste the link below',
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
                  const SizedBox(height: 12),
                  TextField(
                    controller: _linkController,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Paste WhatsApp / Telegram / Discord link',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : AppTheme.primaryColor.withValues(alpha: 0.4),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : AppTheme.backgroundColor.withValues(alpha: 0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      errorText: _groupLinkError.isNotEmpty
                          ? _groupLinkError
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _validateLink,
                      icon: const Icon(Icons.check_circle_rounded, size: 16),
                      label: const Text('Submit Link'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ] else if (_groupLinkError.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.error_rounded,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _groupLinkError,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _groupLinkError = '');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPurple,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Try Again',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

// ─── Reusable Components ──────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _GlassCard({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.backgroundColor.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const _SectionLabel(this.text, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final _TeamMember member;
  final bool isDark;
  const _MemberTile({required this.member, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: member.isLead
                      ? AppTheme.primaryColor
                      : AppTheme.secondaryColor,
                  child: Text(
                    member.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: member.online ? Colors.greenAccent : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.black : Colors.white,
                        width: 1.5,
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
                    member.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    member.role,
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
            if (member.isLead)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Lead',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SuggestedRoomCard extends StatelessWidget {
  final _Room room;
  final bool isDark;
  final int delay;
  final VoidCallback onJoin;

  const _SuggestedRoomCard({
    required this.room,
    required this.isDark,
    required this.delay,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Match %
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withValues(
                          alpha: room.matchPercent / 100,
                        ),
                        AppTheme.secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${room.matchPercent}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor,
                              ),
                            ),
                          ),
                          Text(
                            '${room.members}/${room.maxMembers}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room.event,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : AppTheme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: room.skills
                                  .take(3)
                                  .map(
                                    (s) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        s,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: onJoin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
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
                            child: const Text('Join'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 150 + delay),
          duration: 400.ms,
        )
        .slideX(begin: 0.05, end: 0);
  }
}

// ─── Create Room Dialog ───────────────────────────────────────────────────────
class _CreateRoomDialog extends StatelessWidget {
  final bool isDark;
  final TextEditingController nameCtrl;
  final int maxMembers;
  final ValueChanged<int> onMaxChanged;
  final VoidCallback onClose;
  final VoidCallback onCreate;

  const _CreateRoomDialog({
    required this.isDark,
    required this.nameCtrl,
    required this.maxMembers,
    required this.onMaxChanged,
    required this.onClose,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryDarkColor,
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.meeting_room_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Create New Room',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                            ),
                            onPressed: onClose,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Room Name',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.7,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: nameCtrl,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. Team Alpha',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : AppTheme.primaryColor.withValues(
                                        alpha: 0.4,
                                      ),
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : AppTheme.backgroundColor.withValues(
                                      alpha: 0.4,
                                    ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Max Members',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.7,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [2, 3, 4, 5]
                                .map(
                                  (n) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () => onMaxChanged(n),
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: maxMembers == n
                                              ? const LinearGradient(
                                                  colors: [
                                                    AppTheme.primaryColor,
                                                    AppTheme.primaryDarkColor,
                                                  ],
                                                )
                                              : null,
                                          color: maxMembers == n
                                              ? null
                                              : (isDark
                                                    ? Colors.white.withValues(
                                                        alpha: 0.06,
                                                      )
                                                    : AppTheme.backgroundColor
                                                          .withValues(
                                                            alpha: 0.5,
                                                          )),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: maxMembers == n
                                                  ? Colors.white
                                                  : (isDark
                                                        ? Colors.white
                                                              .withValues(
                                                                alpha: 0.5,
                                                              )
                                                        : AppTheme
                                                              .primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: onCreate,
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                size: 16,
                              ),
                              label: const Text('Create Room'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
          ),
        ),
      ),
    );
  }
}
