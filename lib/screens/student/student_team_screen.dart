import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

// ─── Simple Teams & Pairing — 3-Step Wizard ──────────────────────────────────
// Step 1: Get into a room (join or create)
// Step 2: Find teammates
// Step 3: Lock team → done

class StudentTeamScreen extends StatefulWidget {
  const StudentTeamScreen({super.key});
  @override
  State<StudentTeamScreen> createState() => _State();
}

class _State extends State<StudentTeamScreen> {
  // ── Step state: 1=room, 2=teammates, 3=finalize ──
  int _step = 1;
  bool _inRoom = true; // mock: user is already in a room

  // Room
  static const _inviteCode = 'KH-8492-AC';
  bool _copied = false;
  bool _showRoomDetails = false;
  bool _showCreateDialog = false;
  final _roomNameCtrl = TextEditingController();

  // Teammates
  bool _showMoreRooms = false;
  final Set<int> _joined = {};

  // Team finalize
  int _teamStep = 1; // 1=pending, 2=group chat, 3=done
  bool _groupCreating = false;
  int _countdown = 180;
  String _linkErr = '';
  final _linkCtrl = TextEditingController();
  Timer? _timer;

  // Collab groups (secondary, hidden by default)
  bool _showCollabGroups = false;

  @override
  void dispose() {
    _linkCtrl.dispose();
    _roomNameCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _copyCode() async {
    await Clipboard.setData(ClipboardData(text: _inviteCode));
    setState(() => _copied = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) setState(() => _copied = false);
  }

  void _startTimer() {
    setState(() {
      _groupCreating = true;
      _countdown = 180;
      _linkErr = '';
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_countdown > 0 && _groupCreating)
        setState(() => _countdown--);
      else {
        t.cancel();
        if (_countdown == 0)
          setState(() {
            _groupCreating = false;
            _linkErr = 'Time expired.';
          });
      }
    });
  }

  void _submitLink() {
    final ok = RegExp(
      r'^(https?:\/\/)?(chat\.whatsapp\.com|t\.me|discord\.gg)\/',
    ).hasMatch(_linkCtrl.text.trim());
    if (ok) {
      setState(() {
        _groupCreating = false;
        _linkErr = '';
        _teamStep = 3;
      });
      _timer?.cancel();
    } else
      setState(() => _linkErr = 'Use WhatsApp, Telegram, or Discord link.');
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: AppTheme.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tc = isDark ? Colors.white : AppTheme.textPrimaryColor;
    final sc = isDark
        ? Colors.white60
        : AppTheme.primaryColor.withValues(alpha: 0.5);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 60),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Teams & Pairing',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: tc,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '3 simple steps to form your team.',
                    style: TextStyle(fontSize: 13, color: sc),
                  ),
                  const SizedBox(height: 24),

                  // Step indicator
                  _StepBar(current: _step, isDark: isDark),
                  const SizedBox(height: 28),

                  // ── STEP 1: ROOM ──────────────────────────
                  if (_step == 1) ...[
                    _stepLabel('Step 1', 'Get into a room', isDark),
                    const SizedBox(height: 16),
                    if (_inRoom) ...[
                      // Already in a room — show it
                      _Card(
                        isDark: isDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: tc,
                                        ),
                                      ),
                                      Text(
                                        'Kitahack 2026 · 3/4 members',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: sc,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _dot('Open', Colors.green),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // invite code row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Invite Code',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: sc,
                                        ),
                                      ),
                                      Text(
                                        _inviteCode,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.4,
                                          color: tc,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _copied ? null : _copyCode,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (_copied
                                                  ? Colors.green
                                                  : AppTheme.primaryColor)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _copied ? 'Copied ✓' : 'Share',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _copied
                                            ? Colors.green
                                            : AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // "Show details" toggle (secondary info)
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => setState(
                                () => _showRoomDetails = !_showRoomDetails,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _showRoomDetails
                                        ? 'Hide details'
                                        : 'Show members & more',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(
                                    _showRoomDetails
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    size: 16,
                                    color: AppTheme.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            if (_showRoomDetails) ...[
                              const SizedBox(height: 12),
                              _Divider(isDark),
                              const SizedBox(height: 12),
                              // members
                              ...[
                                'Ahmad Raza · Full-Stack Dev (Lead)',
                                'Sarah Lee · UI/UX Designer',
                                'John Tan · Data Scientist',
                              ].map(
                                (m) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: AppTheme.primaryColor
                                            .withValues(alpha: 0.15),
                                        child: Text(
                                          m[0],
                                          style: const TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          m,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: tc,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // AI pool toggle (secondary)
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 13,
                                    color: sc,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'AI Matching Pool — let AI find your last teammate',
                                      style: TextStyle(fontSize: 12, color: sc),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.75,
                                    child: Switch(
                                      value: false,
                                      onChanged: (_) {},
                                      activeColor: AppTheme.accentPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _PrimaryBtn(
                        'Go to Step 2 — Find Teammates →',
                        onTap: () => setState(() => _step = 2),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => setState(() => _showCreateDialog = true),
                        child: Text(
                          'Or start a new room',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ] else ...[
                      // Not in a room — two options
                      _Card(
                        isDark: isDark,
                        child: Column(
                          children: [
                            _OptionRow(
                              icon: Icons.add_circle_rounded,
                              title: 'Create a room',
                              subtitle: 'Start fresh, invite friends',
                              color: AppTheme.primaryColor,
                              onTap: () =>
                                  setState(() => _showCreateDialog = true),
                            ),
                            _Divider(isDark),
                            _OptionRow(
                              icon: Icons.search_rounded,
                              title: 'Join with code',
                              subtitle: 'Enter a room invite code',
                              color: AppTheme.secondaryColor,
                              onTap: () =>
                                  _showJoinDialog(context, isDark, tc, sc),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],

                  // ── STEP 2: FIND TEAMMATES ────────────────
                  if (_step == 2) ...[
                    _stepLabel('Step 2', 'Find teammates', isDark),
                    const SizedBox(height: 4),
                    Text(
                      'AI-matched rooms based on your profile.',
                      style: TextStyle(fontSize: 12, color: sc),
                    ),
                    const SizedBox(height: 16),
                    // Top 3 rooms always visible
                    ...[0, 1, 2].map(
                      (i) => _RoomItem(
                        i: i,
                        isDark: isDark,
                        tc: tc,
                        sc: sc,
                        joined: _joined.contains(i),
                        onJoin: () {
                          setState(() => _joined.add(i));
                          _toast('Request sent!');
                        },
                      ),
                    ),
                    // More rooms hidden
                    if (_showMoreRooms)
                      _RoomItem(
                        i: 3,
                        isDark: isDark,
                        tc: tc,
                        sc: sc,
                        joined: _joined.contains(3),
                        onJoin: () {
                          setState(() => _joined.add(3));
                          _toast('Request sent!');
                        },
                      ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _showMoreRooms = !_showMoreRooms),
                      child: Text(
                        _showMoreRooms ? '▲ Show fewer' : '▼ Show more rooms',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _OutlineBtn(
                            '← Back',
                            onTap: () => setState(() => _step = 1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: _PrimaryBtn(
                            'Step 3 — Finalize Team →',
                            onTap: () => setState(() => _step = 3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Collab groups — secondary, hidden
                    GestureDetector(
                      onTap: () => setState(
                        () => _showCollabGroups = !_showCollabGroups,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Looking for project/research collabs?',
                            style: TextStyle(fontSize: 12, color: sc),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _showCollabGroups ? 'Hide ▲' : 'Show ▼',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_showCollabGroups) ...[
                      const SizedBox(height: 12),
                      _CollabSection(isDark: isDark, tc: tc, sc: sc),
                    ],
                  ],

                  // ── STEP 3: FINALIZE ──────────────────────
                  if (_step == 3) ...[
                    _stepLabel('Step 3', 'Finalize your team', isDark),
                    const SizedBox(height: 16),
                    // Sub-step tracker
                    _SubStepRow(sub: _teamStep, isDark: isDark),
                    const SizedBox(height: 16),
                    // Team members summary
                    _Card(
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Phoenix',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: tc,
                            ),
                          ),
                          Text(
                            '3/4 members · Kitahack 2026',
                            style: TextStyle(fontSize: 12, color: sc),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: ['Ahmad Raza', 'Sarah Lee', 'John Tan']
                                .map(
                                  (n) => Chip(
                                    label: Text(
                                      n,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? Colors.white
                                            : AppTheme.primaryColor,
                                      ),
                                    ),
                                    backgroundColor: isDark
                                        ? Colors.white.withValues(alpha: 0.07)
                                        : AppTheme.primaryColor.withValues(
                                            alpha: 0.07,
                                          ),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Sub-step actions
                    if (_teamStep == 1) ...[
                      Text(
                        'Ready to lock? This closes the room — no more joining.',
                        style: TextStyle(fontSize: 13, color: sc),
                      ),
                      const SizedBox(height: 12),
                      _PrimaryBtn(
                        '🔒 Finalize Team',
                        onTap: () => setState(() => _teamStep = 2),
                      ),
                    ],
                    if (_teamStep == 2) ...[
                      if (!_groupCreating && _linkErr.isEmpty) ...[
                        Text(
                          'Create a group chat (WhatsApp/Telegram/Discord) and paste the link.',
                          style: TextStyle(fontSize: 13, color: sc),
                        ),
                        const SizedBox(height: 12),
                        _PrimaryBtn(
                          '💬 Create Group Chat',
                          color: AppTheme.accentPurple,
                          onTap: _startTimer,
                        ),
                      ] else if (_groupCreating) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_rounded,
                              size: 15,
                              color: AppTheme.accentPurple,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${_countdown ~/ 60}:${(_countdown % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Paste the invite link below',
                              style: TextStyle(fontSize: 12, color: sc),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _linkCtrl,
                          style: TextStyle(fontSize: 13, color: tc),
                          decoration: InputDecoration(
                            hintText: 'https://chat.whatsapp.com/…',
                            hintStyle: TextStyle(fontSize: 13, color: sc),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.black.withValues(alpha: 0.04),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            errorText: _linkErr.isNotEmpty ? _linkErr : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _PrimaryBtn('Submit Link', onTap: _submitLink),
                      ] else ...[
                        Text(
                          _linkErr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => setState(() => _linkErr = ''),
                          child: const Text(
                            'Try again',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.accentPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                    if (_teamStep == 3) ...[
                      _Card(
                        isDark: isDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            const Text('🚀', style: TextStyle(fontSize: 36)),
                            const SizedBox(height: 8),
                            Text(
                              'Team Ready!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: tc,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Good luck at the hackathon! 🎉',
                              style: TextStyle(fontSize: 13, color: sc),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ).animate().fadeIn().scale(
                        begin: const Offset(0.95, 0.95),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (_teamStep < 3)
                      _OutlineBtn(
                        '← Back to Step 2',
                        onTap: () => setState(() => _step = 2),
                      ),
                  ],
                ],
              ),
            ),
          ),
          // Create room dialog
          if (_showCreateDialog)
            _CreateDialog(
              isDark: isDark,
              ctrl: _roomNameCtrl,
              onClose: () => setState(() => _showCreateDialog = false),
              onCreate: () {
                setState(() {
                  _showCreateDialog = false;
                  _inRoom = true;
                });
                _toast(
                  'Room "${_roomNameCtrl.text.trim().isNotEmpty ? _roomNameCtrl.text.trim() : 'My Room'}" created!',
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _stepLabel(String step, String label, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            step,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  void _showJoinDialog(BuildContext context, bool isDark, Color tc, Color sc) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Join with Code',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: tc,
          ),
        ),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Enter invite code…',
            hintStyle: TextStyle(color: sc),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: sc)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _inRoom = true);
              _toast('Joined room!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}

// ─── Collab Groups Section ────────────────────────────────────────────────────
class _CollabSection extends StatefulWidget {
  final bool isDark;
  final Color tc, sc;
  const _CollabSection({
    required this.isDark,
    required this.tc,
    required this.sc,
  });
  @override
  State<_CollabSection> createState() => _CollabSectionState();
}

class _CollabSectionState extends State<_CollabSection> {
  final Set<int> _joinedGroups = {};
  bool _showNew = false;
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final groups = [
      ('FYP Buddy Finder', 'Final year project partners', 'Project', 12),
      (
        'AI Research Circle',
        'Co-author papers & share research',
        'Research',
        8,
      ),
      ('Side Project Squad', 'Weekend builders, all skills', 'Collab', 23),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...groups.asMap().entries.map((e) {
          final i = e.key;
          final g = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      g.$1[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g.$1,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.tc,
                        ),
                      ),
                      Text(
                        '${g.$4} members · ${g.$3}',
                        style: TextStyle(fontSize: 11, color: widget.sc),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _joinedGroups.contains(i)
                      ? Text(
                          'Joined ✓',
                          key: ValueKey('ok$i'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : GestureDetector(
                          key: ValueKey('j$i'),
                          onTap: () => setState(() => _joinedGroups.add(i)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Join',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
        GestureDetector(
          onTap: () => setState(() => _showNew = !_showNew),
          child: Text(
            _showNew ? '▲ Cancel' : '+ Create your own group',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_showNew) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: 'Group name…',
              filled: true,
              fillColor: widget.isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
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
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() => _showNew = false);
              _nameCtrl.clear();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Create Group',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Room List Item ───────────────────────────────────────────────────────────
final _rooms = [
  ('Team Alpha', 'Kitahack 2026', 92, ['React', 'Node.js']),
  ('Innovators', 'AI Case Competition', 87, ['Python', 'AI/ML']),
  ('Code Warriors', 'Kitahack 2026', 85, ['Flutter', 'Firebase']),
  ('DataMinds', 'Data Science Workshop', 78, ['Pandas', 'Tableau']),
];

class _RoomItem extends StatelessWidget {
  final int i;
  final bool isDark, joined;
  final Color tc, sc;
  final VoidCallback onJoin;
  const _RoomItem({
    required this.i,
    required this.isDark,
    required this.joined,
    required this.tc,
    required this.sc,
    required this.onJoin,
  });
  @override
  Widget build(BuildContext context) {
    final r = _rooms[i];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child:
          Row(
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: r.$3 / 100,
                      strokeWidth: 3.5,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.07),
                      valueColor: AlwaysStoppedAnimation(
                        r.$3 >= 90 ? Colors.green : AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      '${r.$3}%',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: tc,
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
                    Text(
                      r.$1,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: tc,
                      ),
                    ),
                    Text(r.$2, style: TextStyle(fontSize: 11, color: sc)),
                    Wrap(
                      spacing: 4,
                      children: r.$4
                          .map(
                            (s) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                s,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: joined
                    ? const Text(
                        'Sent ✓',
                        key: ValueKey('s'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : GestureDetector(
                        key: const ValueKey('j'),
                        onTap: onJoin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Join',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ).animate().fadeIn(
            delay: Duration(milliseconds: 30 * i),
            duration: 250.ms,
          ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────
class _StepBar extends StatelessWidget {
  final int current;
  final bool isDark;
  const _StepBar({required this.current, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final labels = ['Room', 'Teammates', 'Finalize'];
    return Row(
      children: List.generate(labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: current > (i ~/ 2) + 1
                  ? AppTheme.primaryColor
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1)),
            ),
          );
        }
        final idx = (i ~/ 2) + 1;
        final done = current > idx;
        final active = current == idx;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
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
                                : Colors.black.withValues(alpha: 0.07))),
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
                              : (isDark ? Colors.white38 : Colors.black38),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              labels[idx - 1],
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SubStepRow extends StatelessWidget {
  final int sub;
  final bool isDark;
  const _SubStepRow({required this.sub, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final steps = ['Finalize', 'Group Chat', 'Done'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd)
          return Expanded(
            child: Container(
              height: 1.5,
              color: sub > (i ~/ 2) + 1
                  ? AppTheme.primaryColor
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1)),
            ),
          );
        final idx = (i ~/ 2) + 1;
        final done = sub > idx;
        final active = sub == idx;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? Colors.green
                    : (active
                          ? AppTheme.primaryColor
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.07))),
              ),
              child: Center(
                child: done
                    ? const Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      )
                    : Text(
                        '$idx',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: active
                              ? Colors.white
                              : (isDark ? Colors.white38 : Colors.black38),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              steps[idx - 1],
              style: TextStyle(
                fontSize: 9,
                color: active
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Card extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _Card({required this.isDark, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.07),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider(this.isDark);
  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    thickness: 0.5,
    color: isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08),
  );
}

Widget _dot(String label, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  decoration: BoxDecoration(
    color: color.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    label,
    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
  ),
);

class _OptionRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _OptionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? Colors.white60
                          : AppTheme.primaryColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark ? Colors.white30 : Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _PrimaryBtn(
    this.label, {
    required this.onTap,
    this.color = AppTheme.primaryColor,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineBtn(this.label, {required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}

// ─── Create Room Dialog ───────────────────────────────────────────────────────
class _CreateDialog extends StatelessWidget {
  final bool isDark;
  final TextEditingController ctrl;
  final VoidCallback onClose, onCreate;
  const _CreateDialog({
    required this.isDark,
    required this.ctrl,
    required this.onClose,
    required this.onCreate,
  });
  @override
  Widget build(BuildContext context) {
    final tc = isDark ? Colors.white : AppTheme.textPrimaryColor;
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'New Room',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: tc,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: tc.withOpacity(0.4),
                          ),
                          onPressed: onClose,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: ctrl,
                      style: TextStyle(fontSize: 14, color: tc),
                      decoration: InputDecoration(
                        hintText: 'e.g. Team Alpha',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: onCreate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Create Room',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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
