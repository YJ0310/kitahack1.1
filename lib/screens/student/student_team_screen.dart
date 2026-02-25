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
  int _selectedTab = 0;

  // Room State
  String _inviteCode = 'KH-8492-AC';
  bool _isAIPoolActive = false;
  bool _codeCopied = false;

  // My Team Step Wizard
  bool _isTeamFormed = false;
  int _teamStep = 1; // 1 = Finalize, 2 = Group Chat, 3 = Done
  bool _isCreatingGroup = false;
  int _countdownSeconds = 180;
  String _groupLinkError = '';
  final _linkController = TextEditingController();
  Timer? _timer;

  // Create Room Dialog
  bool _showCreateRoom = false;
  final _roomNameCtrl = TextEditingController();
  int _roomMaxMembers = 4;

  // Find Rooms search
  String _roomSearch = '';

  // Join state per room (by index)
  final Set<int> _joinedRooms = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _linkController.dispose();
    _roomNameCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _copyCode() async {
    await Clipboard.setData(ClipboardData(text: _inviteCode));
    setState(() => _codeCopied = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _codeCopied = false);
  }

  void _startCountdown() {
    setState(() {
      _isCreatingGroup = true;
      _countdownSeconds = 180;
      _groupLinkError = '';
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
        _teamStep = 3;
      });
      _timer?.cancel();
    } else {
      setState(
        () => _groupLinkError = 'Use a WhatsApp, Telegram, or Discord link.',
      );
    }
  }

  void _switchTab(int i) {
    setState(() => _selectedTab = i);
    _tabController.animateTo(i);
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
              // ── Header ──
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
                      'Find your people — no learning curve required.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                    ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
                    const SizedBox(height: 20),
                    // ── iOS Segmented Control ──
                    _SegmentedControl(
                      labels: const ['My Room', 'Find Rooms', 'My Team'],
                      selected: _selectedTab,
                      isDark: isDark,
                      onTap: _switchTab,
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                  _toast(
                    'Room "${_roomNameCtrl.text.trim().isNotEmpty ? _roomNameCtrl.text.trim() : 'My Room'}" created!',
                    Colors.green,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  SnackBar _toast(String msg, Color color) => SnackBar(
    content: Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg)),
      ],
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 2),
  );

  // ─── My Room Tab ─────────────────────────────────────────────────────────
  Widget _buildMyRoomTab(bool isDark) {
    final filled = _myTeamMembers.length;
    final total = 4;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Room Status Card ──
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                          Text(
                            'Kitahack 2026',
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
                // ── Member Progress Bar ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Members',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.6)
                            : AppTheme.primaryColor.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '$filled / $total',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: filled / total,
                    minHeight: 8,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : AppTheme.backgroundColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),
                ),
                // ── Member Avatars row ──
                const SizedBox(height: 14),
                Row(
                  children: [
                    ..._myTeamMembers.map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _AvatarDot(
                          name: m.name,
                          isLead: m.isLead,
                          online: m.online,
                          isDark: isDark,
                        ),
                      ),
                    ),
                    // empty slot
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : AppTheme.primaryColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : AppTheme.primaryColor.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Waiting for 1 more…',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : AppTheme.primaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // ── Invite Code ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : AppTheme.backgroundColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.vpn_key_rounded,
                        size: 16,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invite Code',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : AppTheme.primaryColor.withValues(
                                        alpha: 0.6,
                                      ),
                              ),
                            ),
                            Text(
                              _inviteCode,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Copy button with ✓ feedback
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _codeCopied
                            ? Container(
                                key: const ValueKey('check'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Copied!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                key: const ValueKey('copy'),
                                onTap: _copyCode,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.copy_rounded,
                                        size: 14,
                                        color: AppTheme.primaryColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Copy',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // ── AI Matching Pool Toggle ──
                _AIPoolToggle(
                  isDark: isDark,
                  active: _isAIPoolActive,
                  onChanged: (v) => setState(() => _isAIPoolActive = v),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
          const SizedBox(height: 14),
          // ── Create New Room ──
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _showCreateRoom = true),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('Start a New Room'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.18)
                      : AppTheme.primaryColor.withValues(alpha: 0.35),
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
    final filtered = _suggestedRooms.where((r) {
      if (_roomSearch.isEmpty) return true;
      final q = _roomSearch.toLowerCase();
      return r.name.toLowerCase().contains(q) ||
          r.event.toLowerCase().contains(q) ||
          r.skills.any((s) => s.toLowerCase().contains(q));
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search Bar ──
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppTheme.backgroundColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              onChanged: (v) => setState(() => _roomSearch = v),
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : AppTheme.textPrimaryColor,
              ),
              decoration: InputDecoration(
                hintText: 'Search hackathons or skills…',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.3)
                      : AppTheme.primaryColor.withValues(alpha: 0.4),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : AppTheme.primaryColor.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: AppTheme.accentPurple,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AI-Suggested Rooms',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                ),
              ),
              const Spacer(),
              Text(
                'Based on your profile',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : AppTheme.primaryColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 40,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No rooms match "$_roomSearch"',
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
            )
          else
            ...filtered.asMap().entries.map(
              (e) => _SuggestedRoomCard(
                room: e.value,
                isDark: isDark,
                delay: e.key * 80,
                joined: _joinedRooms.contains(e.key),
                onJoin: () {
                  setState(() => _joinedRooms.add(e.key));
                  ScaffoldMessenger.of(context).showSnackBar(
                    _toast(
                      'Join request sent to ${e.value.name}!',
                      Colors.green,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // ─── My Team Tab ─────────────────────────────────────────────────────────
  Widget _buildMyTeamTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Step Progress ──
          _StepProgress(
            current: _teamStep,
            isDark: isDark,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 16),

          // ── Step 1: Finalize Team ──
          if (_teamStep == 1) ...[
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor,
                              ),
                            ),
                            Text(
                              'Room active · Waiting for members',
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
                      _StatusBadge(label: 'Building', color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'When everyone is ready, finalize to lock the team. No one can join or leave after this.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.55)
                          : AppTheme.primaryColor.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() {
                        _isTeamFormed = true;
                        _teamStep = 2;
                      }),
                      icon: const Icon(Icons.lock_rounded, size: 16),
                      label: const Text('Finalize Team'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
            _SectionLabel(
              'Team Members',
              Icons.people_rounded,
              AppTheme.secondaryColor,
            ),
            const SizedBox(height: 10),
            ..._myTeamMembers.map(
              (m) => _MemberTile(member: m, isDark: isDark),
            ),
          ],

          // ── Step 2: Group Chat ──
          if (_teamStep == 2) ...[
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
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Team Finalized! 🎉',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor,
                              ),
                            ),
                            Text(
                              'Now set up your group chat',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(label: 'Formed', color: Colors.green),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 60.ms, duration: 400.ms),
            const SizedBox(height: 16),
            _SectionLabel(
              'Team Members',
              Icons.people_rounded,
              AppTheme.secondaryColor,
            ),
            const SizedBox(height: 10),
            ..._myTeamMembers.map(
              (m) => _MemberTile(member: m, isDark: isDark),
            ),
            const SizedBox(height: 16),
            // Group Chat card
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
                  if (!_isCreatingGroup && _groupLinkError.isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'One member creates the group chat and shares the link here.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.55)
                                : AppTheme.primaryColor.withValues(alpha: 0.65),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _startCountdown,
                            icon: const Icon(
                              Icons.chat_bubble_rounded,
                              size: 16,
                            ),
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
                        ),
                      ],
                    )
                  else if (_isCreatingGroup) ...[
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
                          const Icon(
                            Icons.timer_rounded,
                            size: 18,
                            color: AppTheme.accentPurple,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(_countdownSeconds ~/ 60).toString().padLeft(2, '0')}:${(_countdownSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentPurple,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Create then paste link below',
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
                    const SizedBox(height: 12),
                    TextField(
                      controller: _linkController,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
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
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () => setState(() {
                            _groupLinkError = '';
                          }),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppTheme.accentPurple,
                            ),
                            foregroundColor: AppTheme.accentPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          ],

          // ── Step 3: Done ──
          if (_teamStep == 3) ...[
            _GlassCard(
                  isDark: isDark,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.rocket_launch_rounded,
                        size: 48,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your team is ready! 🚀',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Group chat is live. Good luck at the hackathon!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.55)
                              : AppTheme.primaryColor.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatusBadge(
                            label: 'Team Formed',
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          _StatusBadge(
                            label: 'Chat Ready',
                            color: AppTheme.accentPurple,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),
            const SizedBox(height: 16),
            _SectionLabel(
              'Team Members',
              Icons.people_rounded,
              AppTheme.secondaryColor,
            ),
            const SizedBox(height: 10),
            ..._myTeamMembers.map(
              (m) => _MemberTile(member: m, isDark: isDark),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── iOS Segmented Control ────────────────────────────────────────────────────
class _SegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final bool isDark;
  final ValueChanged<int> onTap;
  const _SegmentedControl({
    required this.labels,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : AppTheme.backgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active
                      ? (isDark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                  gradient: active
                      ? const LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryDarkColor,
                          ],
                        )
                      : null,
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active
                        ? Colors.white
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : AppTheme.primaryColor.withValues(alpha: 0.6)),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Step Progress ────────────────────────────────────────────────────────────
class _StepProgress extends StatelessWidget {
  final int current;
  final bool isDark;
  const _StepProgress({required this.current, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final steps = ['Finalize Team', 'Group Chat', 'Ready!'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepIndex = (i ~/ 2) + 1;
          final done = current > stepIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: done
                  ? AppTheme.primaryColor
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : AppTheme.backgroundColor),
            ),
          );
        }
        final stepIndex = (i ~/ 2) + 1;
        final done = current > stepIndex;
        final active = current == stepIndex;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? Colors.green
                    : (active
                          ? AppTheme.primaryColor
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : AppTheme.backgroundColor)),
                border: Border.all(
                  color: done
                      ? Colors.green
                      : (active ? AppTheme.primaryColor : Colors.transparent),
                  width: 2,
                ),
              ),
              child: Center(
                child: done
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.white,
                      )
                    : Text(
                        '$stepIndex',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: active
                              ? Colors.white
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : AppTheme.primaryColor.withValues(
                                        alpha: 0.4,
                                      )),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              steps[stepIndex - 1],
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? AppTheme.primaryColor
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : AppTheme.primaryColor.withValues(alpha: 0.5)),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Avatar Dot ───────────────────────────────────────────────────────────────
class _AvatarDot extends StatelessWidget {
  final String name;
  final bool isLead;
  final bool online;
  final bool isDark;
  const _AvatarDot({
    required this.name,
    required this.isLead,
    required this.online,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isLead
              ? AppTheme.primaryColor
              : AppTheme.secondaryColor,
          child: Text(
            name[0],
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
              color: online ? Colors.greenAccent : Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.black : Colors.white,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── AI Pool Toggle ───────────────────────────────────────────────────────────
class _AIPoolToggle extends StatelessWidget {
  final bool isDark;
  final bool active;
  final ValueChanged<bool> onChanged;
  const _AIPoolToggle({
    required this.isDark,
    required this.active,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: active
            ? LinearGradient(
                colors: [
                  AppTheme.accentPurple.withValues(alpha: 0.12),
                  AppTheme.primaryColor.withValues(alpha: 0.08),
                ],
              )
            : null,
        color: active
            ? null
            : (isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppTheme.backgroundColor.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active
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
            color: active
                ? AppTheme.accentPurple
                : (isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : AppTheme.primaryColor.withValues(alpha: 0.5)),
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
                    color: active
                        ? AppTheme.accentPurple
                        : (isDark ? Colors.white : AppTheme.textPrimaryColor),
                  ),
                ),
                Text(
                  active
                      ? 'Scanning for compatible teammates…'
                      : 'Let AI find you the perfect teammate',
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
          Switch(
            value: active,
            onChanged: onChanged,
            activeColor: AppTheme.accentPurple,
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            color: isDark ? Colors.white : AppTheme.textPrimaryColor,
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
            _AvatarDot(
              name: member.name,
              isLead: member.isLead,
              online: member.online,
              isDark: isDark,
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
  final bool joined;
  final VoidCallback onJoin;
  const _SuggestedRoomCard({
    required this.room,
    required this.isDark,
    required this.delay,
    required this.joined,
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
                // Match % circular indicator
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: room.matchPercent / 100,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppTheme.backgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          room.matchPercent >= 90
                              ? Colors.green
                              : (room.matchPercent >= 80
                                    ? AppTheme.primaryColor
                                    : AppTheme.secondaryColor),
                        ),
                        strokeWidth: 4,
                      ),
                      Text(
                        '${room.matchPercent}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
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
                            '${room.members}/${room.maxMembers} members',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
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
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: joined
                                ? Container(
                                    key: const ValueKey('sent'),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_rounded,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Sent',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ElevatedButton(
                                    key: const ValueKey('join'),
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
        .slideX(begin: 0.04, end: 0);
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
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryDarkColor,
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(
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
                              'Start a New Room',
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
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
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
