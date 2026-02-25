import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

// ─── Mock Data ────────────────────────────────────────────────────────────────
class _Member {
  final String name;
  final String role;
  final bool isLead;
  final bool online;
  _Member(this.name, this.role, {this.isLead = false, this.online = true});
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

final _myMembers = [
  _Member('Ahmad Raza', 'Full-Stack Developer', isLead: true),
  _Member('Sarah Lee', 'UI/UX Designer'),
  _Member('John Tan', 'Data Scientist', online: false),
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

class _StudentTeamScreenState extends State<StudentTeamScreen> {
  // Room
  String _inviteCode = 'KH-8492-AC';
  bool _isAIPoolActive = false;
  bool _codeCopied = false;
  bool _showCreateRoom = false;
  final _roomNameCtrl = TextEditingController();
  int _roomMaxMembers = 4;

  // Find Rooms
  String _roomSearch = '';
  final Set<int> _joinedRooms = {};

  // My Team wizard
  // 1 = not finalized, 2 = finalized (set up chat), 3 = done
  int _teamStep = 1;
  bool _isCreatingGroup = false;
  int _countdownSeconds = 180;
  String _groupLinkError = '';
  final _linkController = TextEditingController();
  Timer? _timer;

  @override
  void dispose() {
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
            _groupLinkError = 'Time expired. Try again.';
          });
        }
      }
    });
  }

  void _validateLink() {
    final link = _linkController.text.trim();
    final ok = RegExp(
      r'^(https?:\/\/)?(chat\.whatsapp\.com|t\.me|discord\.gg)\/.*$',
    ).hasMatch(link);
    if (ok) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Page Header ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
                        'Everything you need, right here.',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : AppTheme.primaryColor.withValues(alpha: 0.6),
                        ),
                      ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ),

              // ─────────────────────────────────────────────────────────────
              // SECTION 1 — YOUR ROOM
              // ─────────────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.meeting_room_rounded,
                        label: 'Your Room',
                        color: AppTheme.primaryColor,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _GlassCard(
                        isDark: isDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Room name + status
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              ? Colors.white.withValues(
                                                  alpha: 0.5,
                                                )
                                              : AppTheme.primaryColor
                                                    .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _Chip('Open', Colors.green),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Member progress bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Members',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.55)
                                        : AppTheme.primaryColor.withValues(
                                            alpha: 0.7,
                                          ),
                                  ),
                                ),
                                Text(
                                  '${_myMembers.length} / 4',
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
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: _myMembers.length / 4,
                                minHeight: 7,
                                backgroundColor: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : AppTheme.backgroundColor,
                                valueColor: const AlwaysStoppedAnimation(
                                  AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Member avatar row
                            Row(
                              children: [
                                ..._myMembers.map(
                                  (m) => Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Tooltip(
                                      message: '${m.name} · ${m.role}',
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: m.isLead
                                                ? AppTheme.primaryColor
                                                : AppTheme.secondaryColor,
                                            child: Text(
                                              m.name[0],
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
                                                color: m.online
                                                    ? Colors.greenAccent
                                                    : Colors.grey,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: isDark
                                                      ? Colors.black
                                                      : Colors.white,
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                          : AppTheme.primaryColor.withValues(
                                              alpha: 0.25,
                                            ),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : AppTheme.primaryColor.withValues(
                                            alpha: 0.4,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '1 spot open',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.4)
                                        : AppTheme.primaryColor.withValues(
                                            alpha: 0.5,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Divider(height: 1, thickness: 0.5),
                            const SizedBox(height: 14),
                            // Invite code
                            Row(
                              children: [
                                Icon(
                                  Icons.vpn_key_rounded,
                                  size: 15,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Invite Code',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.4,
                                                )
                                              : AppTheme.primaryColor
                                                    .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      Text(
                                        _inviteCode,
                                        style: TextStyle(
                                          fontSize: 15,
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
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: _codeCopied
                                      ? _outlineBtn(
                                          key: const ValueKey('ok'),
                                          icon: Icons.check_rounded,
                                          label: 'Copied!',
                                          color: Colors.green,
                                          onTap: null,
                                        )
                                      : _outlineBtn(
                                          key: const ValueKey('copy'),
                                          icon: Icons.copy_rounded,
                                          label: 'Copy',
                                          color: AppTheme.primaryColor,
                                          onTap: _copyCode,
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // AI Pool banner
                            _AIPoolRow(
                              isDark: isDark,
                              active: _isAIPoolActive,
                              onChanged: (v) =>
                                  setState(() => _isAIPoolActive = v),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              setState(() => _showCreateRoom = true),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Start a New Room'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.18)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                            ),
                            foregroundColor: isDark
                                ? Colors.white60
                                : AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ),

              // ─────────────────────────────────────────────────────────────
              // SECTION 2 — FIND A ROOM
              // ─────────────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: _SectionHeader(
                    icon: Icons.auto_awesome_rounded,
                    label: 'Find a Room',
                    color: AppTheme.accentPurple,
                    isDark: isDark,
                    subtitle: 'AI-matched based on your profile',
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              ),
              // Search box
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                  child: Container(
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
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.15 : 0.04,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _roomSearch = v),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by event, team, or skill…',
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
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 220.ms, duration: 400.ms),
              ),
              // Room cards
              SliverList(
                delegate: SliverChildBuilderDelegate((ctx, i) {
                  final filtered = _suggestedRooms.where((r) {
                    if (_roomSearch.isEmpty) return true;
                    final q = _roomSearch.toLowerCase();
                    return r.name.toLowerCase().contains(q) ||
                        r.event.toLowerCase().contains(q) ||
                        r.skills.any((s) => s.toLowerCase().contains(q));
                  }).toList();
                  if (i == filtered.length) return const SizedBox(height: 20);
                  if (i > filtered.length) return null;
                  // show empty state
                  if (filtered.isEmpty && i == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 36,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.2,
                                    ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No rooms match "$_roomSearch"',
                              style: TextStyle(
                                fontSize: 13,
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
                    );
                  }
                  final room = filtered[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                    child: _RoomCard(
                      room: room,
                      isDark: isDark,
                      delay: i * 60,
                      joined: _joinedRooms.contains(i),
                      onJoin: () {
                        setState(() => _joinedRooms.add(i));
                        ScaffoldMessenger.of(context).showSnackBar(
                          _toast('Request sent to ${room.name}!', Colors.green),
                        );
                      },
                    ),
                  );
                }, childCount: _suggestedRooms.length + 1),
              ),

              // ─────────────────────────────────────────────────────────────
              // SECTION 3 — YOUR TEAM
              // ─────────────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.groups_rounded,
                        label: 'Your Team',
                        color: AppTheme.secondaryColor,
                        isDark: isDark,
                        subtitle: _teamStep == 3
                            ? 'Ready to go 🚀'
                            : (_teamStep == 2
                                  ? 'Step 2 of 3 — Set up group chat'
                                  : 'Step 1 of 3 — Finalize when ready'),
                      ),
                      const SizedBox(height: 12),
                      // Step indicator
                      _StepRow(current: _teamStep, isDark: isDark),
                      const SizedBox(height: 14),
                      // Members
                      ..._myMembers.map(
                        (m) => _MemberRow(m: m, isDark: isDark),
                      ),
                      const SizedBox(height: 14),
                      // Step-based CTA
                      if (_teamStep == 1)
                        _GlassCard(
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ready to lock in your team?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : AppTheme.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Once you finalize, no one can join or leave. Make sure all members are in.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.5)
                                      : AppTheme.primaryColor.withValues(
                                          alpha: 0.6,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      setState(() => _teamStep = 2),
                                  icon: const Icon(
                                    Icons.lock_rounded,
                                    size: 16,
                                  ),
                                  label: const Text('Finalize Team'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
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
                      if (_teamStep == 2)
                        _GlassCard(
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Team finalized!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Now create a group chat and paste the invite link here.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.5)
                                      : AppTheme.primaryColor.withValues(
                                          alpha: 0.6,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (!_isCreatingGroup &&
                                  _groupLinkError.isEmpty) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _startCountdown,
                                    icon: const Icon(
                                      Icons.chat_bubble_rounded,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      "I'll Create the Group Chat",
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentPurple,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 13,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ] else if (_isCreatingGroup) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentPurple.withValues(
                                      alpha: 0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppTheme.accentPurple.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.timer_rounded,
                                        size: 16,
                                        color: AppTheme.accentPurple,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${(_countdownSeconds ~/ 60).toString().padLeft(2, '0')}:${(_countdownSeconds % 60).toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentPurple,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Create then paste link below',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.45,
                                                )
                                              : AppTheme.primaryColor
                                                    .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _linkController,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white
                                        : AppTheme.textPrimaryColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Paste WhatsApp / Telegram / Discord link',
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
                                  child: ElevatedButton(
                                    onPressed: _validateLink,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Submit Link'),
                                  ),
                                ),
                              ] else if (_groupLinkError.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.red.withValues(alpha: 0.25),
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
                                  onPressed: () =>
                                      setState(() => _groupLinkError = ''),
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
                            ],
                          ),
                        ),
                      if (_teamStep == 3)
                        _GlassCard(
                              isDark: isDark,
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.rocket_launch_rounded,
                                    size: 40,
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Team is ready! 🚀',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : AppTheme.textPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Good luck at the hackathon!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.5)
                                          : AppTheme.primaryColor.withValues(
                                              alpha: 0.6,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _Chip('Team Formed', Colors.green),
                                      const SizedBox(width: 8),
                                      _Chip(
                                        'Chat Ready',
                                        AppTheme.accentPurple,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .scale(
                              begin: const Offset(0.95, 0.95),
                              end: const Offset(1, 1),
                            ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ).animate().fadeIn(delay: 280.ms, duration: 500.ms),
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

  Widget _outlineBtn({
    Key? key,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step Row ─────────────────────────────────────────────────────────────────
class _StepRow extends StatelessWidget {
  final int current;
  final bool isDark;
  const _StepRow({required this.current, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final steps = ['Finalize', 'Group Chat', 'Done'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final done = current > (i ~/ 2) + 1;
          return Expanded(
            child: Container(
              height: 2,
              color: done
                  ? AppTheme.primaryColor
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : AppTheme.backgroundColor),
            ),
          );
        }
        final idx = (i ~/ 2) + 1;
        final done = current > idx;
        final active = current == idx;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? Colors.green
                    : (active
                          ? AppTheme.primaryColor
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppTheme.backgroundColor)),
              ),
              child: Center(
                child: done
                    ? const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: Colors.white,
                      )
                    : Text(
                        '$idx',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: active
                              ? Colors.white
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.35)
                                    : AppTheme.primaryColor.withValues(
                                        alpha: 0.4,
                                      )),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              steps[idx - 1],
              style: TextStyle(
                fontSize: 9,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? AppTheme.primaryColor
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : AppTheme.primaryColor.withValues(alpha: 0.45)),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── AI Pool Row ─────────────────────────────────────────────────────────────
class _AIPoolRow extends StatelessWidget {
  final bool isDark, active;
  final ValueChanged<bool> onChanged;
  const _AIPoolRow({
    required this.isDark,
    required this.active,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? AppTheme.accentPurple.withValues(alpha: 0.1)
            : (isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppTheme.backgroundColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? AppTheme.accentPurple.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 16,
            color: active
                ? AppTheme.accentPurple
                : (isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : AppTheme.primaryColor.withValues(alpha: 0.5)),
          ),
          const SizedBox(width: 8),
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
                      : 'Let AI find you a teammate',
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
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final String? subtitle;
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.textPrimaryColor,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : AppTheme.primaryColor.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─── Glass Card ───────────────────────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _GlassCard({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppTheme.backgroundColor.withValues(alpha: 0.7),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

// ─── Chip ─────────────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
    ),
  );
}

// ─── Member Row ───────────────────────────────────────────────────────────────
class _MemberRow extends StatelessWidget {
  final _Member m;
  final bool isDark;
  const _MemberRow({required this.m, required this.isDark});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : AppTheme.backgroundColor.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: m.isLead
                    ? AppTheme.primaryColor
                    : AppTheme.secondaryColor,
                child: Text(
                  m.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: m.online ? Colors.greenAccent : Colors.grey,
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
                  m.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                  ),
                ),
                Text(
                  m.role,
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
          if (m.isLead) _Chip('Lead', AppTheme.primaryColor),
        ],
      ),
    ),
  );
}

// ─── Room Card ────────────────────────────────────────────────────────────────
class _RoomCard extends StatelessWidget {
  final _Room room;
  final bool isDark, joined;
  final int delay;
  final VoidCallback onJoin;
  const _RoomCard({
    required this.room,
    required this.isDark,
    required this.delay,
    required this.joined,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(14),
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
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular match indicator
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: room.matchPercent / 100,
                      strokeWidth: 4,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppTheme.backgroundColor,
                      valueColor: AlwaysStoppedAnimation(
                        room.matchPercent >= 90
                            ? Colors.green
                            : AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      '${room.matchPercent}%',
                      style: TextStyle(
                        fontSize: 10,
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
                          '${room.members}/${room.maxMembers}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.45)
                                : AppTheme.primaryColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      room.event,
                      style: TextStyle(
                        fontSize: 11,
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
                                      horizontal: 7,
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
                                        fontSize: 9,
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
                          duration: const Duration(milliseconds: 250),
                          child: joined
                              ? Container(
                                  key: const ValueKey('sent'),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_rounded,
                                        size: 13,
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
                                      horizontal: 14,
                                      vertical: 7,
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
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 250 + delay),
          duration: 400.ms,
        )
        .slideY(begin: 0.04, end: 0);
  }
}

// ─── Create Room Dialog ───────────────────────────────────────────────────────
class _CreateRoomDialog extends StatelessWidget {
  final bool isDark;
  final TextEditingController nameCtrl;
  final int maxMembers;
  final ValueChanged<int> onMaxChanged;
  final VoidCallback onClose, onCreate;
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
              constraints: const BoxConstraints(maxWidth: 420),
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
                      padding: const EdgeInsets.all(18),
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
                                fontSize: 16,
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
                      padding: const EdgeInsets.all(18),
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
                          const SizedBox(height: 18),
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
