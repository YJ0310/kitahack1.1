import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────
class _Member {
  final String name, role;
  final bool isLead, online;
  _Member(this.name, this.role, {this.isLead = false, this.online = true});
}

class _HackRoom {
  final String name, event;
  final int members, maxMembers, matchPercent;
  final List<String> skills;
  _HackRoom(
    this.name,
    this.members,
    this.maxMembers,
    this.skills,
    this.event,
    this.matchPercent,
  );
}

class _CollabGroup {
  String name, description, type;
  int members;
  bool isOwn;
  _CollabGroup({
    required this.name,
    required this.description,
    required this.type,
    required this.members,
    this.isOwn = false,
  });
}

final _myMembers = [
  _Member('Ahmad Raza', 'Full-Stack Dev', isLead: true),
  _Member('Sarah Lee', 'UI/UX Designer'),
  _Member('John Tan', 'Data Scientist', online: false),
];

final _hackRooms = [
  _HackRoom('Team Alpha', 2, 4, ['React', 'Node.js'], 'Kitahack 2026', 92),
  _HackRoom('Innovators', 3, 5, ['Python', 'AI/ML'], 'AI Case Competition', 87),
  _HackRoom(
    'Code Warriors',
    1,
    4,
    ['Flutter', 'Firebase'],
    'Kitahack 2026',
    85,
  ),
  _HackRoom(
    'DataMinds',
    2,
    3,
    ['Pandas', 'Tableau'],
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
  bool _copied = false;
  bool _aiPool = false;
  bool _showCreate = false;
  String _search = '';
  final Set<int> _joined = {};

  // Team wizard
  int _teamStep = 1;
  bool _groupCreating = false;
  int _countdown = 180;
  String _linkErr = '';
  final _linkCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  int _maxMembers = 4;
  Timer? _timer;

  // Collab Groups
  final List<_CollabGroup> _collabGroups = [
    _CollabGroup(
      name: 'FYP Buddy Finder',
      description: 'Looking for final-year project partners',
      type: 'Project',
      members: 12,
    ),
    _CollabGroup(
      name: 'AI Research Circle',
      description: 'Share research & co-author papers',
      type: 'Research',
      members: 8,
    ),
    _CollabGroup(
      name: 'Side Project Squad',
      description: 'Weekend builders, all skills welcome',
      type: 'Collab',
      members: 23,
    ),
  ];
  bool _showNewGroup = false;
  final _groupNameCtrl = TextEditingController();
  final _groupDescCtrl = TextEditingController();
  String _groupType = 'Project';
  final Set<int> _joinedGroups = {};

  @override
  void dispose() {
    _linkCtrl.dispose();
    _nameCtrl.dispose();
    _groupNameCtrl.dispose();
    _groupDescCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _copy() async {
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
      if (_countdown > 0 && _groupCreating) {
        setState(() => _countdown--);
      } else {
        t.cancel();
        if (_countdown == 0)
          setState(() {
            _groupCreating = false;
            _linkErr = 'Time expired. Try again.';
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
    } else {
      setState(() => _linkErr = 'Use a WhatsApp, Telegram, or Discord link.');
    }
  }

  void _createCollabGroup() {
    final name = _groupNameCtrl.text.trim();
    final desc = _groupDescCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _collabGroups.insert(
        0,
        _CollabGroup(
          name: name,
          description: desc.isNotEmpty ? desc : 'No description',
          type: _groupType,
          members: 1,
          isOwn: true,
        ),
      );
      _showNewGroup = false;
      _groupNameCtrl.clear();
      _groupDescCtrl.clear();
      _groupType = 'Project';
    });
    _toast('Group "$name" created!');
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
        : AppTheme.primaryColor.withValues(alpha: 0.55);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 60),
            children: [
              // Title
              Text(
                'Teams & Pairing',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: tc,
                ),
              ).animate().fadeIn(duration: 350.ms),
              const SizedBox(height: 2),
              Text(
                'Room, teammates, and collab groups — all here.',
                style: TextStyle(fontSize: 13, color: sc),
              ).animate().fadeIn(delay: 50.ms),
              const SizedBox(height: 28),

              // ══════════════════════════════
              // YOUR ROOM
              // ══════════════════════════════
              _sectionLabel('YOUR ROOM', isDark),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Kitahack 2026',
                          style: TextStyle(fontSize: 12, color: sc),
                        ),
                      ],
                    ),
                  ),
                  _badge('Open', Colors.green),
                ],
              ),
              const SizedBox(height: 12),
              // Member avatars
              Row(
                children: [
                  ..._myMembers.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _avatar(
                        m.name[0],
                        m.isLead
                            ? AppTheme.primaryColor
                            : AppTheme.secondaryColor,
                        online: m.online,
                        isDark: isDark,
                      ),
                    ),
                  ),
                  _emptyAvatar(isDark),
                  const SizedBox(width: 8),
                  Text(
                    '${_myMembers.length}/4',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: sc,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _myMembers.length / 4,
                  minHeight: 5,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.07),
                  valueColor: const AlwaysStoppedAnimation(
                    AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Invite code
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invite Code',
                          style: TextStyle(fontSize: 11, color: sc),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _inviteCode,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: tc,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _copied ? null : _copy,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: (_copied ? Colors.green : AppTheme.primaryColor)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _copied ? 'Copied ✓' : 'Copy',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _copied ? Colors.green : AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // AI Pool
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 15,
                    color: _aiPool ? AppTheme.accentPurple : sc,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _aiPool ? 'AI Matching: Scanning…' : 'AI Matching Pool',
                      style: TextStyle(
                        fontSize: 13,
                        color: _aiPool ? AppTheme.accentPurple : tc,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: _aiPool,
                      onChanged: (v) => setState(() => _aiPool = v),
                      activeColor: AppTheme.accentPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => setState(() => _showCreate = true),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '+ Start a new room',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              _divider(isDark),
              const SizedBox(height: 24),

              // ══════════════════════════════
              // FIND A ROOM
              // ══════════════════════════════
              _sectionLabel('FIND A ROOM', isDark),
              const SizedBox(height: 12),
              // Search
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.07)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: TextStyle(fontSize: 13, color: tc),
                  decoration: InputDecoration(
                    hintText: 'Search event, team, or skill…',
                    hintStyle: TextStyle(fontSize: 13, color: sc),
                    prefixIcon: Icon(Icons.search_rounded, size: 18, color: sc),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Room cards
              ..._buildRoomCards(isDark, tc, sc),

              const SizedBox(height: 28),
              _divider(isDark),
              const SizedBox(height: 24),

              // ══════════════════════════════
              // COLLAB GROUPS
              // ══════════════════════════════
              Row(
                children: [
                  Expanded(child: _sectionLabel('COLLAB GROUPS', isDark)),
                  GestureDetector(
                    onTap: () => setState(() => _showNewGroup = true),
                    child: Text(
                      '+ Create',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Start or join groups for projects, research, or anything else.',
                style: TextStyle(fontSize: 12, color: sc),
              ),
              const SizedBox(height: 14),
              ..._buildCollabGroups(isDark, tc, sc),

              const SizedBox(height: 28),
              _divider(isDark),
              const SizedBox(height: 24),

              // ══════════════════════════════
              // YOUR TEAM
              // ══════════════════════════════
              Row(
                children: [
                  Expanded(child: _sectionLabel('YOUR TEAM', isDark)),
                  _badge(
                    _teamStep == 3
                        ? 'Ready 🚀'
                        : (_teamStep == 2 ? 'Forming' : 'Building'),
                    _teamStep == 3 ? Colors.green : AppTheme.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _stepTracker(_teamStep, isDark),
              const SizedBox(height: 14),
              ..._myMembers.map((m) => _memberRow(m, isDark, tc, sc)),
              const SizedBox(height: 14),
              ..._buildTeamStep(isDark, tc, sc),
            ],
          ),
          // Overlays
          if (_showCreate)
            _CreateRoomSheet(
              isDark: isDark,
              nameCtrl: _nameCtrl,
              max: _maxMembers,
              onMax: (v) => setState(() => _maxMembers = v),
              onClose: () => setState(() => _showCreate = false),
              onCreate: () {
                setState(() {
                  _showCreate = false;
                  _inviteCode =
                      'KH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}-AC';
                });
                _toast(
                  'Room "${_nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'My Room'}" created!',
                );
              },
            ),
          if (_showNewGroup)
            _NewGroupSheet(
              isDark: isDark,
              nameCtrl: _groupNameCtrl,
              descCtrl: _groupDescCtrl,
              type: _groupType,
              onType: (v) => setState(() => _groupType = v),
              onClose: () => setState(() => _showNewGroup = false),
              onCreate: _createCollabGroup,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRoomCards(bool isDark, Color tc, Color sc) {
    final filtered = _hackRooms.where((r) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return r.name.toLowerCase().contains(q) ||
          r.event.toLowerCase().contains(q) ||
          r.skills.any((s) => s.toLowerCase().contains(q));
    }).toList();

    if (filtered.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'No rooms match "$_search"',
            style: TextStyle(fontSize: 13, color: sc),
          ),
        ),
      ];
    }

    return filtered.asMap().entries.map((e) {
      final i = e.key;
      final room = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child:
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: room.matchPercent / 100,
                        strokeWidth: 3.5,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.07),
                        valueColor: AlwaysStoppedAnimation(
                          room.matchPercent >= 90
                              ? Colors.green
                              : AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        '${room.matchPercent}%',
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: tc,
                              ),
                            ),
                          ),
                          Text(
                            '${room.members}/${room.maxMembers}',
                            style: TextStyle(fontSize: 11, color: sc),
                          ),
                        ],
                      ),
                      Text(
                        room.event,
                        style: TextStyle(fontSize: 11, color: sc),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: room.skills
                            .take(2)
                            .map(
                              (s) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.09,
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
                const SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _joined.contains(i)
                      ? Text(
                          'Sent ✓',
                          key: const ValueKey('s'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : GestureDetector(
                          key: const ValueKey('j'),
                          onTap: () {
                            setState(() => _joined.add(i));
                            _toast('Request sent to ${room.name}!');
                          },
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
              delay: Duration(milliseconds: 50 * i),
              duration: 300.ms,
            ),
      );
    }).toList();
  }

  List<Widget> _buildCollabGroups(bool isDark, Color tc, Color sc) {
    return _collabGroups.asMap().entries.map((e) {
      final i = e.key;
      final g = e.value;
      final typeColor = g.type == 'Research'
          ? AppTheme.accentPurple
          : (g.type == 'Collab'
                ? AppTheme.secondaryColor
                : AppTheme.primaryColor);
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child:
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      g.name[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                        fontSize: 16,
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
                              g.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: tc,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              g.type,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: typeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        g.description,
                        style: TextStyle(fontSize: 11, color: sc),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${g.members} member${g.members != 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 11, color: sc),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: g.isOwn
                      ? Text(
                          'Yours',
                          key: ValueKey('own$i'),
                          style: TextStyle(
                            fontSize: 12,
                            color: sc,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : _joinedGroups.contains(i)
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
                          key: ValueKey('jg$i'),
                          onTap: () {
                            setState(() => _joinedGroups.add(i));
                            _toast('Joined ${g.name}!');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Join',
                              style: TextStyle(
                                fontSize: 12,
                                color: typeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ).animate().fadeIn(
              delay: Duration(milliseconds: 40 * i),
              duration: 300.ms,
            ),
      );
    }).toList();
  }

  List<Widget> _buildTeamStep(bool isDark, Color tc, Color sc) {
    if (_teamStep == 1)
      return [
        Text(
          'Everyone in? Lock the team to proceed.',
          style: TextStyle(fontSize: 13, color: sc),
        ),
        const SizedBox(height: 10),
        _primaryBtn(
          'Finalize Team',
          Icons.lock_rounded,
          () => setState(() => _teamStep = 2),
        ),
      ];

    if (_teamStep == 2) {
      if (!_groupCreating && _linkErr.isEmpty)
        return [
          Text(
            'Create a group chat and share the invite link here.',
            style: TextStyle(fontSize: 13, color: sc),
          ),
          const SizedBox(height: 10),
          _primaryBtn(
            "I'll Create the Group Chat",
            Icons.chat_bubble_rounded,
            _startTimer,
            color: AppTheme.accentPurple,
          ),
        ];

      if (_groupCreating)
        return [
          Row(
            children: [
              const Icon(
                Icons.timer_rounded,
                size: 15,
                color: AppTheme.accentPurple,
              ),
              const SizedBox(width: 6),
              Text(
                '${(_countdown ~/ 60).toString().padLeft(2, '0')}:${(_countdown % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentPurple,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Paste link below',
                style: TextStyle(fontSize: 12, color: sc),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _linkCtrl,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
            decoration: InputDecoration(
              hintText: 'Paste WhatsApp / Telegram / Discord link',
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
          _primaryBtn('Submit Link', Icons.check_rounded, _submitLink),
        ];

      return [
        Text(_linkErr, style: const TextStyle(fontSize: 12, color: Colors.red)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _linkErr = ''),
          child: Text(
            'Try again',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.accentPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ];
    }

    return [
      Row(
        children: [
          const Icon(
            Icons.rocket_launch_rounded,
            size: 18,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Team formed and group chat is live!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        'Good luck at the hackathon 🎉',
        style: TextStyle(
          fontSize: 13,
          color: isDark
              ? Colors.white60
              : AppTheme.primaryColor.withValues(alpha: 0.55),
        ),
      ),
    ];
  }

  // ── Helpers ──
  Widget _sectionLabel(String text, bool isDark) => Text(
    text,
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
      color: isDark
          ? Colors.white.withValues(alpha: 0.35)
          : Colors.black.withValues(alpha: 0.35),
    ),
  );

  Widget _badge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
    ),
  );

  Widget _divider(bool isDark) => Divider(
    height: 1,
    thickness: 0.5,
    color: isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1),
  );

  Widget _avatar(
    String letter,
    Color color, {
    required bool online,
    required bool isDark,
  }) => Stack(
    children: [
      CircleAvatar(
        radius: 17,
        backgroundColor: color,
        child: Text(
          letter,
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

  Widget _emptyAvatar(bool isDark) => Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.15),
        width: 1.5,
      ),
    ),
    child: Icon(
      Icons.add,
      size: 14,
      color: isDark
          ? Colors.white.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.3),
    ),
  );

  Widget _memberRow(_Member m, bool isDark, Color tc, Color sc) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        _avatar(
          m.name[0],
          m.isLead ? AppTheme.primaryColor : AppTheme.secondaryColor,
          online: m.online,
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                m.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tc,
                ),
              ),
              Text(m.role, style: TextStyle(fontSize: 11, color: sc)),
            ],
          ),
        ),
        if (m.isLead)
          Text(
            'Lead',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    ),
  );

  Widget _primaryBtn(
    String label,
    IconData icon,
    VoidCallback onTap, {
    Color color = AppTheme.primaryColor,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _stepTracker(int step, bool isDark) {
    final steps = ['Finalize', 'Group Chat', 'Done'];
    final items = <Widget>[];
    for (int i = 0; i < steps.length; i++) {
      final idx = i + 1;
      final done = step > idx;
      final active = step == idx;
      items.add(
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 26,
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
                        size: 14,
                        color: Colors.white,
                      )
                    : Text(
                        '$idx',
                        style: TextStyle(
                          fontSize: 11,
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
              steps[i],
              style: TextStyle(
                fontSize: 9,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          ],
        ),
      );
      if (i < steps.length - 1) {
        items.add(
          Expanded(
            child: Container(
              height: 1.5,
              color: step > idx
                  ? AppTheme.primaryColor
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1)),
            ),
          ),
        );
      }
    }
    return Row(children: items);
  }
}

// ─── Create Room Sheet ────────────────────────────────────────────────────────
class _CreateRoomSheet extends StatelessWidget {
  final bool isDark;
  final TextEditingController nameCtrl;
  final int max;
  final ValueChanged<int> onMax;
  final VoidCallback onClose, onCreate;
  const _CreateRoomSheet({
    required this.isDark,
    required this.nameCtrl,
    required this.max,
    required this.onMax,
    required this.onClose,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final tc = isDark ? Colors.white : AppTheme.textPrimaryColor;
    final sc = isDark
        ? Colors.white60
        : AppTheme.primaryColor.withValues(alpha: 0.55);
    return _Sheet(
      isDark: isDark,
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sheetHeader('New Room', onClose, tc),
          const SizedBox(height: 16),
          _fieldLabel('Room Name', sc),
          const SizedBox(height: 6),
          _field(nameCtrl, 'e.g. Team Alpha', isDark, tc, sc),
          const SizedBox(height: 14),
          _fieldLabel('Max Members', sc),
          const SizedBox(height: 8),
          Row(
            children: [2, 3, 4, 5]
                .map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => onMax(n),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: max == n
                              ? AppTheme.primaryColor
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.07)
                                    : Colors.black.withValues(alpha: 0.06)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '$n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: max == n
                                  ? Colors.white
                                  : (isDark
                                        ? Colors.white60
                                        : AppTheme.primaryColor),
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
          _btn('Create Room', onCreate),
        ],
      ),
    );
  }
}

// ─── New Collab Group Sheet ───────────────────────────────────────────────────
class _NewGroupSheet extends StatelessWidget {
  final bool isDark;
  final TextEditingController nameCtrl, descCtrl;
  final String type;
  final ValueChanged<String> onType;
  final VoidCallback onClose, onCreate;
  const _NewGroupSheet({
    required this.isDark,
    required this.nameCtrl,
    required this.descCtrl,
    required this.type,
    required this.onType,
    required this.onClose,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final tc = isDark ? Colors.white : AppTheme.textPrimaryColor;
    final sc = isDark
        ? Colors.white60
        : AppTheme.primaryColor.withValues(alpha: 0.55);
    final types = ['Project', 'Research', 'Collab'];
    return _Sheet(
      isDark: isDark,
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sheetHeader('New Collab Group', onClose, tc),
          const SizedBox(height: 6),
          Text(
            'Create a group for any collab — projects, research, or just to connect.',
            style: TextStyle(fontSize: 12, color: sc),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Group Name', sc),
          const SizedBox(height: 6),
          _field(nameCtrl, 'e.g. FYP Buddy Finder', isDark, tc, sc),
          const SizedBox(height: 12),
          _fieldLabel('Description (optional)', sc),
          const SizedBox(height: 6),
          _field(descCtrl, 'What is this group about?', isDark, tc, sc),
          const SizedBox(height: 12),
          _fieldLabel('Type', sc),
          const SizedBox(height: 8),
          Row(
            children: types
                .map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => onType(t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: type == t
                              ? AppTheme.primaryColor
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.07)
                                    : Colors.black.withValues(alpha: 0.06)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: type == t
                                ? Colors.white
                                : (isDark
                                      ? Colors.white60
                                      : AppTheme.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          _btn('Create Group', onCreate),
        ],
      ),
    );
  }
}

// ─── Shared Sheet Wrapper ─────────────────────────────────────────────────────
class _Sheet extends StatelessWidget {
  final bool isDark;
  final VoidCallback onClose;
  final Widget child;
  const _Sheet({
    required this.isDark,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onClose,
    child: Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: Center(
        child: GestureDetector(
          onTap: () {},
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

// ─── Sheet Helpers ────────────────────────────────────────────────────────────
Widget _sheetHeader(String title, VoidCallback onClose, Color tc) => Row(
  children: [
    Expanded(
      child: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tc),
      ),
    ),
    IconButton(
      icon: Icon(Icons.close_rounded, color: tc.withOpacity(0.5)),
      onPressed: onClose,
      visualDensity: VisualDensity.compact,
    ),
  ],
);

Widget _fieldLabel(String label, Color sc) => Text(
  label,
  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sc),
);

Widget _field(
  TextEditingController ctrl,
  String hint,
  bool isDark,
  Color tc,
  Color sc,
) => TextField(
  controller: ctrl,
  style: TextStyle(fontSize: 14, color: tc),
  decoration: InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 14, color: sc),
    filled: true,
    fillColor: isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.04),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  ),
);

Widget _btn(String label, VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 13),
    decoration: BoxDecoration(
      color: AppTheme.primaryColor,
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
