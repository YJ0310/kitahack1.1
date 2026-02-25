import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

// ─── Types ────────────────────────────────────────────────────────────────────
class _Member {
  final String name, faculty;
  final List<String> skills;
  final bool isLeader, isOnline;
  const _Member({
    required this.name,
    required this.faculty,
    required this.skills,
    this.isLeader = false,
    this.isOnline = false,
  });
}

class _Room {
  final String id, name, event, eventDate, hostName;
  final List<String> skills;
  final int members, maxMembers, matchPct;
  const _Room({
    required this.id,
    required this.name,
    required this.event,
    required this.eventDate,
    required this.hostName,
    required this.skills,
    required this.members,
    required this.maxMembers,
    required this.matchPct,
  });
}

class _CollabGroup {
  final String name, desc, type;
  final String description;
  final int count;
  const _CollabGroup({
    required this.name,
    required this.desc,
    required this.type,
    required this.count,
    this.description = '',
  });
}

// ─── Mock data ────────────────────────────────────────────────────────────────
const _myMembers = [
  _Member(
    name: 'Ahmad Raza',
    faculty: 'Computer Science',
    skills: ['Flutter', 'Firebase'],
    isLeader: true,
    isOnline: true,
  ),
  _Member(
    name: 'Sarah Lee',
    faculty: 'UI/UX Design',
    skills: ['Figma', 'React'],
    isOnline: true,
  ),
  _Member(name: 'John Tan', faculty: 'Data Science', skills: ['Python', 'ML']),
];

const _hackRooms = [
  _Room(
    id: 'r1',
    name: 'Team Alpha',
    event: 'Kitahack 2026',
    eventDate: 'Mar 15',
    hostName: 'Wei Ming',
    skills: ['React', 'Node.js'],
    members: 2,
    maxMembers: 4,
    matchPct: 92,
  ),
  _Room(
    id: 'r2',
    name: 'Innovators',
    event: 'AI Case Competition',
    eventDate: 'Mar 20',
    hostName: 'Priya S.',
    skills: ['Python', 'AI/ML'],
    members: 3,
    maxMembers: 4,
    matchPct: 87,
  ),
  _Room(
    id: 'r3',
    name: 'Code Warriors',
    event: 'Kitahack 2026',
    eventDate: 'Mar 15',
    hostName: 'Ali Hassan',
    skills: ['Flutter', 'Firebase'],
    members: 1,
    maxMembers: 4,
    matchPct: 85,
  ),
  _Room(
    id: 'r4',
    name: 'DataMinds',
    event: 'Data Challenge',
    eventDate: 'Mar 22',
    hostName: 'Maya C.',
    skills: ['Pandas', 'Tableau'],
    members: 3,
    maxMembers: 4,
    matchPct: 78,
  ),
  _Room(
    id: 'r5',
    name: 'FullStack Squad',
    event: 'Kitahack 2026',
    eventDate: 'Mar 15',
    hostName: 'Kevin L.',
    skills: ['Vue', 'Django'],
    members: 2,
    maxMembers: 4,
    matchPct: 74,
  ),
];

const _collabGroups = [
  _CollabGroup(
    name: 'FYP Buddy Finder',
    desc: 'Final year project partners',
    description:
        'Find the perfect partner for your final year project. Connect with students across faculties.',
    type: 'Project',
    count: 12,
  ),
  _CollabGroup(
    name: 'AI Research Circle',
    desc: 'Co-author papers & share research',
    description:
        'Co-author papers, share datasets, and collaborate on cutting-edge AI research.',
    type: 'Research',
    count: 8,
  ),
  _CollabGroup(
    name: 'Side Project Squad',
    desc: 'Weekend builders, all skills',
    description:
        'Weekend builders of all skill levels. Ship something cool together.',
    type: 'Collab',
    count: 23,
  ),
  _CollabGroup(
    name: 'UM LeetCode Club',
    desc: 'Daily coding challenges together',
    description:
        'Tackle daily coding challenges together and ace your technical interviews.',
    type: 'Study',
    count: 31,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────
class StudentTeamScreen extends StatefulWidget {
  const StudentTeamScreen({super.key});
  @override
  State<StudentTeamScreen> createState() => _State();
}

class _State extends State<StudentTeamScreen> {
  int _step = 1;
  int _teamStep = 1; // finalize sub-steps
  bool _inRoom = true;

  // Step 1 expand
  bool _showDetails = false;
  bool _showAiPool = false;

  // Step 2
  String _filter = 'all';
  bool _showMore = false;
  bool _showCollab = false;
  final Set<String> _joined = {};

  // Step 3
  String? _platform;
  bool _copied = false;
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _copyCode() async {
    await Clipboard.setData(const ClipboardData(text: 'KH-8492-AC'));
    setState(() => _copied = true);
    await Future.delayed(1400.ms);
    if (mounted) setState(() => _copied = false);
  }

  List<_Room> get _filtered {
    final src = _showMore ? _hackRooms : _hackRooms.take(3).toList();
    if (_filter == 'high-match')
      return src.where((r) => r.matchPct >= 85).toList();
    if (_filter == 'available')
      return src.where((r) => r.members < r.maxMembers).toList();
    return src;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Sticky progress header ──
          _ProgressHeader(step: _step, isDark: isDark),
          // ── Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: [
                    _buildStep1(isDark),
                    _buildStep2(isDark),
                    _buildStep3(isDark),
                  ][_step - 1],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP 1 ────────────────────────────────────────────────────────────────
  Widget _buildStep1(bool isDark) {
    final tc = isDark ? Colors.white : const Color(0xFF0F172A);
    final sc = isDark ? Colors.white60 : const Color(0xFF64748B);

    if (!_inRoom) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Join or Create a Room',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: tc,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start your hackathon journey by joining an existing team or creating your own room.',
            style: TextStyle(fontSize: 13, color: sc),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ChoiceCard(
                  icon: Icons.add_circle_outline_rounded,
                  color: AppTheme.primaryColor,
                  title: 'Create a Room',
                  subtitle: 'Start fresh and invite teammates.',
                  btnLabel: 'Create Room',
                  isDark: isDark,
                  onTap: () => _showCreateDialog(isDark),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ChoiceCard(
                  icon: Icons.groups_rounded,
                  color: AppTheme.accentPurple,
                  title: 'Join a Room',
                  subtitle: 'Have an invite code? Browse existing teams.',
                  btnLabel: 'Browse Rooms',
                  isDark: isDark,
                  onTap: () => _showJoinDialog(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _AiBanner(
            isDark: isDark,
            msg:
                'Not sure where to start? Let AI analyse your skills and find the perfect team.',
          ),
        ],
      ).animate().fadeIn(duration: 250.ms).slideX(begin: -0.03, end: 0);
    }

    // Already in room
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Room',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: tc,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your team or continue to find teammates.',
          style: TextStyle(fontSize: 13, color: sc),
        ),
        const SizedBox(height: 20),
        _RCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Project Phoenix Room',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: tc,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _Chip('Active', Colors.green),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 13,
                              color: sc,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kitahack 2026 · Mar 15',
                              style: TextStyle(fontSize: 12, color: sc),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.group_rounded, size: 13, color: sc),
                            const SizedBox(width: 4),
                            Text(
                              '3/4 members',
                              style: TextStyle(fontSize: 12, color: sc),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Settings btn
                  _GhostBtn(
                    Icons.settings_rounded,
                    isDark: isDark,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Skills
              Wrap(
                spacing: 6,
                children: [
                  'Flutter',
                  'Firebase',
                  'Python',
                ].map((s) => _SkillBadge(s, isDark)).toList(),
              ),
              const SizedBox(height: 14),
              // Stacked avatars
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 36,
                    child: Stack(
                      children: [_ava('A', 0), _ava('S', 20), _ava('J', 40)],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ahmad, Sarah and 1 more',
                    style: TextStyle(fontSize: 13, color: sc),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Invite code row
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invite Code',
                            style: TextStyle(fontSize: 10, color: sc),
                          ),
                          Text(
                            'KH-8492-AC',
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
                      onTap: _copyCode,
                      child: AnimatedContainer(
                        duration: 200.ms,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (_copied ? Colors.green : AppTheme.primaryColor)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _copied ? 'Copied ✓' : 'Copy',
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
              ),
              const SizedBox(height: 10),
              // Expandable
              GestureDetector(
                onTap: () => setState(() => _showDetails = !_showDetails),
                child: Row(
                  children: [
                    Icon(
                      _showDetails
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _showDetails ? 'Hide details' : 'Show member details',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showDetails) ...[
                const SizedBox(height: 14),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 12),
                Text(
                  'Team Members',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: sc,
                  ),
                ),
                const SizedBox(height: 8),
                ..._myMembers.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.primaryColor.withValues(
                              alpha: 0.15,
                            ),
                            child: Text(
                              m.name[0],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      m.name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: tc,
                                      ),
                                    ),
                                    if (m.isLeader) ...[
                                      const SizedBox(width: 6),
                                      _Chip('Leader', AppTheme.primaryColor),
                                    ],
                                  ],
                                ),
                                Text(
                                  m.faculty,
                                  style: TextStyle(fontSize: 11, color: sc),
                                ),
                              ],
                            ),
                          ),
                          Wrap(
                            spacing: 4,
                            children: m.skills
                                .take(2)
                                .map((s) => _SkillBadge(s, isDark))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // AI pool toggle
                GestureDetector(
                  onTap: () => setState(() => _showAiPool = !_showAiPool),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF3E8FF), Color(0xFFFCE7F3)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'AI-Matched Candidates',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        _Chip('3 available', AppTheme.accentPurple),
                        const SizedBox(width: 4),
                        Icon(
                          _showAiPool
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: const Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showAiPool) ...[
                  const SizedBox(height: 10),
                  _AiCandidateRow(
                    name: 'Lim Wei Chen',
                    pct: 90,
                    isDark: isDark,
                  ),
                  _AiCandidateRow(
                    name: 'Fatimah Ahmad',
                    pct: 86,
                    isDark: isDark,
                  ),
                  _AiCandidateRow(name: 'Raj Kumar', pct: 82, isDark: isDark),
                ],
              ],
              // Actions
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _PBtn(
                      'Continue to Teammates',
                      onTap: () => setState(() => _step = 2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _OutlineIconBtn(
                    Icons.person_add_rounded,
                    'Invite',
                    isDark: isDark,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _OutlineIconBtn(
                    Icons.logout_rounded,
                    'Leave',
                    isDark: isDark,
                    onTap: () => setState(() {
                      _inRoom = false;
                    }),
                    danger: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 250.ms).slideX(begin: -0.03, end: 0);
  }

  Widget _ava(String l, double left) => Positioned(
    left: left,
    child: CircleAvatar(
      radius: 16,
      backgroundColor: AppTheme.primaryColor,
      child: Text(
        l,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  // ── STEP 2 ────────────────────────────────────────────────────────────────
  Widget _buildStep2(bool isDark) {
    final tc = isDark ? Colors.white : const Color(0xFF0F172A);
    final sc = isDark ? Colors.white60 : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Teammates',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: tc,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Browse AI-matched rooms or explore collaboration groups.',
                    style: TextStyle(fontSize: 13, color: sc),
                  ),
                ],
              ),
            ),
            _OutlineIconBtn(
              Icons.arrow_back_rounded,
              'Back',
              isDark: isDark,
              onTap: () => setState(() => _step = 1),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // AI insight banner
        _AiInsightBanner(isDark: isDark, roomCount: _hackRooms.length),
        const SizedBox(height: 16),
        // Filter chips
        Row(
          children: [
            Icon(Icons.filter_list_rounded, size: 16, color: sc),
            const SizedBox(width: 8),
            ...['all', 'high-match', 'available'].map((f) {
              final labels = {
                'all': 'All Rooms',
                'high-match': '85%+ Match',
                'available': 'Has Openings',
              };
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: AnimatedContainer(
                    duration: 150.ms,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _filter == f
                          ? AppTheme.primaryColor.withValues(alpha: 0.1)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _filter == f
                            ? AppTheme.primaryColor.withValues(alpha: 0.4)
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      labels[f]!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _filter == f ? AppTheme.primaryColor : sc,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
        // Section label
        Row(
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 15,
              color: Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 6),
            Text(
              'AI-Matched Rooms',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: tc,
              ),
            ),
            const SizedBox(width: 8),
            _Chip('${_hackRooms.length} found', AppTheme.accentPurple),
          ],
        ),
        const SizedBox(height: 12),
        // Room cards
        ..._filtered.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RCard(
              isDark: isDark,
              hover: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: sc,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  r.event,
                                  style: TextStyle(fontSize: 12, color: sc),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.group_rounded, size: 12, color: sc),
                                const SizedBox(width: 4),
                                Text(
                                  '${r.members}/${r.maxMembers}',
                                  style: TextStyle(fontSize: 12, color: sc),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              size: 11,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${r.matchPct}% match',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppTheme.secondaryColor,
                        child: Text(
                          r.hostName[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Hosted by ',
                        style: TextStyle(fontSize: 12, color: sc),
                      ),
                      Text(
                        r.hostName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Required Skills',
                    style: TextStyle(fontSize: 11, color: sc),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: r.skills
                        .map((s) => _SkillBadge(s, isDark))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 0.5),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AnimatedSwitcher(
                        duration: 200.ms,
                        child: _joined.contains(r.id)
                            ? Container(
                                key: const ValueKey('ok'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Request Sent',
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
                                key: const ValueKey('j'),
                                onTap: () => setState(() => _joined.add(r.id)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Request to Join',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 12,
                            color: sc,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 30.ms, duration: 250.ms),
          ),
        ),
        // Show more
        if (_hackRooms.length > 3)
          GestureDetector(
            onTap: () => setState(() => _showMore = !_showMore),
            child: Row(
              children: [
                Icon(
                  _showMore
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  _showMore
                      ? 'Show less'
                      : 'Show ${_hackRooms.length - 3} more rooms',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        // Collab groups Section
        const Divider(height: 1, thickness: 0.5),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _showCollab = !_showCollab),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.people_rounded,
                  size: 18,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collaboration Groups',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Join study groups, guilds and communities',
                      style: TextStyle(fontSize: 12, color: sc),
                    ),
                  ],
                ),
              ),
              _Chip('${_collabGroups.length}', Colors.indigo),
              const SizedBox(width: 4),
              Icon(
                _showCollab
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
        if (_showCollab) ...[
          const SizedBox(height: 12),
          ..._collabGroups.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _CollabCategoryBadge(g.type),
                        const Spacer(),
                        Icon(Icons.group_rounded, size: 14, color: sc),
                        const SizedBox(width: 4),
                        Text(
                          '${g.count}',
                          style: TextStyle(fontSize: 12, color: sc),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      g.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      g.description.isNotEmpty ? g.description : g.desc,
                      style: TextStyle(fontSize: 12, color: sc),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : const Color(0xFFE2E8F0),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Join Group',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF374151),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        // Continue
        const Divider(height: 1, thickness: 0.5),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: _PBtn(
            'Continue to Finalize →',
            onTap: () => setState(() => _step = 3),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 250.ms).slideX(begin: -0.03, end: 0);
  }

  // ── STEP 3 ────────────────────────────────────────────────────────────────
  Widget _buildStep3(bool isDark) {
    final tc = isDark ? Colors.white : const Color(0xFF0F172A);
    final sc = isDark ? Colors.white60 : const Color(0xFF64748B);

    // Sub-step 1: confirm lock
    if (_teamStep == 1) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Finalize Your Team',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: tc,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Review your team and lock it to start collaborating.',
                      style: TextStyle(fontSize: 13, color: sc),
                    ),
                  ],
                ),
              ),
              _OutlineIconBtn(
                Icons.arrow_back_rounded,
                'Back',
                isDark: isDark,
                onTap: () => setState(() => _step = 2),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _RCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room info header
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.group_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Phoenix Room',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: tc,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: sc,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Kitahack 2026',
                                style: TextStyle(fontSize: 12, color: sc),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text('·', style: TextStyle(color: sc)),
                              ),
                              Text(
                                'Mar 15',
                                style: TextStyle(fontSize: 12, color: sc),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _Chip('Pending Lock', Colors.amber.shade700),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 14),
                Text(
                  'Team Members (${_myMembers.length}/4)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: sc,
                  ),
                ),
                const SizedBox(height: 10),
                ..._myMembers.asMap().entries.map((e) {
                  final m = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child:
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppTheme.primaryColor
                                    .withValues(alpha: 0.15),
                                child: Text(
                                  m.name[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          m.name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: tc,
                                          ),
                                        ),
                                        if (m.isLeader) ...[
                                          const SizedBox(width: 6),
                                          _Chip(
                                            'Leader',
                                            AppTheme.primaryColor,
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      m.faculty,
                                      style: TextStyle(fontSize: 11, color: sc),
                                    ),
                                  ],
                                ),
                              ),
                              Wrap(
                                spacing: 4,
                                children: m.skills
                                    .take(2)
                                    .map((s) => _SkillBadge(s, isDark))
                                    .toList(),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(
                          delay: Duration(milliseconds: 80 * e.key),
                          duration: 250.ms,
                        ),
                  );
                }),
                const SizedBox(height: 12),
                // Skills coverage
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF3E8FF), Color(0xFFFCE7F3)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 13,
                            color: Color(0xFF8B5CF6),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Team Skills Coverage',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children:
                            ['Flutter', 'Firebase', 'Python', 'Figma', 'ML']
                                .map(
                                  (s) => Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF8B5CF6),
                                          Color(0xFFEC4899),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      s,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
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
                const SizedBox(height: 12),
                // Warning
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    '⚠️ Once locked: No more members can join. Make sure you have everyone you need.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _GhostWideBtn(
                  'Go Back',
                  onTap: () => setState(() => _step = 2),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PBtn(
                  '🔒  Lock Team',
                  onTap: () => setState(() => _teamStep = 2),
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 250.ms).slideX(begin: -0.03, end: 0);
    }

    // Sub-step 2: choose platform
    if (_teamStep == 2) {
      final platforms = [
        (
          'whatsapp',
          'WhatsApp',
          '💬',
          'Great for mobile-first communication',
          const [Color(0xFF22C55E), Color(0xFF10B981)],
        ),
        (
          'telegram',
          'Telegram',
          '✈️',
          'Perfect for file sharing & bots',
          const [Color(0xFF3B82F6), Color(0xFF06B6D4)],
        ),
        (
          'discord',
          'Discord',
          '🎮',
          'Best for voice chat & screen sharing',
          const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ];
      return Column(
        children: [
          const SizedBox(height: 12),
          // Success checkmark
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 30,
            ),
          ).animate().scale(begin: const Offset(0, 0)),
          const SizedBox(height: 12),
          Text(
            'Team Locked! 🎉',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: tc,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Now let's set up a group chat for your team communication.",
            style: TextStyle(fontSize: 13, color: sc),
          ),
          const SizedBox(height: 24),
          _RCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.chat_rounded,
                      size: 18,
                      color: Color(0xFF0EA5E9),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Choose a Chat Platform',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: tc,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...platforms.map((p) {
                  final selected = _platform == p.$1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _platform = p.$1),
                      child: AnimatedContainer(
                        duration: 150.ms,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AppTheme.primaryColor
                                : (isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : const Color(0xFFE2E8F0)),
                            width: selected ? 2 : 1,
                          ),
                          color: selected
                              ? AppTheme.primaryColor.withValues(alpha: 0.05)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: p.$5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  p.$3,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.$2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: tc,
                                    ),
                                  ),
                                  Text(
                                    p.$4,
                                    style: TextStyle(fontSize: 12, color: sc),
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Don't worry — you can also use the in-app team chat anytime!",
                      style: TextStyle(fontSize: 12, color: sc),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _GhostWideBtn(
                'Skip for Now',
                onTap: () => setState(() => _teamStep = 3),
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PBtn(
                  'Create Group & Continue',
                  onTap: _platform != null
                      ? () => setState(() => _teamStep = 3)
                      : () {},
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 250.ms).slideX(begin: -0.03, end: 0);
    }

    // Sub-step 3: Done
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
        ).animate().scale(
          begin: const Offset(0, 0),
          duration: 600.ms,
          curve: Curves.elasticOut,
        ),
        const SizedBox(height: 20),
        Text(
          "You're All Set! 🚀",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: tc,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 15, color: sc),
            children: const [
              TextSpan(
                text: 'Project Phoenix Room',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextSpan(text: ' is ready for '),
              TextSpan(
                text: 'Kitahack 2026',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        // Stacked avatars
        SizedBox(
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ..._myMembers.asMap().entries.map(
                (e) => Positioned(
                  left:
                      (MediaQuery.of(context).size.width / 2) -
                      70 +
                      e.key * 38.0,
                  child:
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          e.value.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ).animate().fadeIn(
                        delay: Duration(milliseconds: 200 + e.key * 100),
                        duration: 300.ms,
                      ),
                ),
              ),
            ],
          ),
        ),
        if (_platform != null) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '✅ A ${_platform![0].toUpperCase()}${_platform!.substring(1)} group link has been sent to all team members!',
              style: const TextStyle(fontSize: 13, color: Color(0xFF166534)),
            ),
          ),
        ],
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GhostWideBtn('View Team Chat', onTap: () {}, isDark: isDark),
            const SizedBox(width: 12),
            _PBtn('Go to Dashboard', onTap: () {}),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.97, 0.97));
  }

  void _showCreateDialog(bool isDark) {
    final nameCtrl = TextEditingController();
    final eventCtrl = TextEditingController();
    final tagCtrl = TextEditingController();
    final List<String> selectedTags = [];
    String selectedEvent = '';

    const suggestedEvents = [
      'KitaHack 2026',
      'Google Cloud Jam',
      'AppDev Challenge',
      'Analytics Summit',
    ];
    const suggestedSkills = [
      'AI/ML',
      'Web Dev',
      'Mobile',
      'Backend',
      'UI/UX',
      'Data Science',
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        final tc = isDark ? Colors.white : const Color(0xFF0F172A);
        final sc = isDark ? Colors.white60 : const Color(0xFF64748B);
        return StatefulBuilder(
          builder: (ctx, setDlgState) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Create a Room',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: tc,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room name
                  TextField(
                    controller: nameCtrl,
                    style: TextStyle(fontSize: 14, color: tc),
                    decoration: InputDecoration(
                      labelText: 'Room Name',
                      hintText: 'e.g. Team Alpha',
                      labelStyle: TextStyle(fontSize: 13, color: sc),
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : const Color(0xFFF8FAFC),
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
                  const SizedBox(height: 14),
                  // Event field
                  TextField(
                    controller: eventCtrl,
                    style: TextStyle(fontSize: 14, color: tc),
                    decoration: InputDecoration(
                      labelText: 'Event / Hackathon',
                      hintText: 'Select or type event name',
                      labelStyle: TextStyle(fontSize: 13, color: sc),
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: sc,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : const Color(0xFFF8FAFC),
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
                  const SizedBox(height: 8),
                  // Suggested events
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: suggestedEvents
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              eventCtrl.text = e;
                              setDlgState(() => selectedEvent = e);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: selectedEvent == e
                                    ? AppTheme.primaryColor.withValues(
                                        alpha: 0.12,
                                      )
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.07)
                                          : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selectedEvent == e
                                      ? AppTheme.primaryColor.withValues(
                                          alpha: 0.4,
                                        )
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: selectedEvent == e
                                      ? AppTheme.primaryColor
                                      : sc,
                                  fontWeight: selectedEvent == e
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  // Tags section
                  Text(
                    'Skills / Tags',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: sc,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Selected tags as removable chips
                  if (selectedTags.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: selectedTags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => setDlgState(
                                      () => selectedTags.remove(tag),
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 13,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Custom tag input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tagCtrl,
                          style: TextStyle(fontSize: 13, color: tc),
                          decoration: InputDecoration(
                            hintText: 'Add a tag...',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontSize: 12,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            isDense: true,
                          ),
                          onSubmitted: (v) {
                            if (v.trim().isNotEmpty &&
                                !selectedTags.contains(v.trim())) {
                              setDlgState(() {
                                selectedTags.add(v.trim());
                                tagCtrl.clear();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          final v = tagCtrl.text.trim();
                          if (v.isNotEmpty && !selectedTags.contains(v)) {
                            setDlgState(() {
                              selectedTags.add(v);
                              tagCtrl.clear();
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : const Color(0xFFE2E8F0),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 12,
                              color: sc,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Suggested skill chips
                  Text('Suggested:', style: TextStyle(fontSize: 11, color: sc)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: suggestedSkills
                        .where((s) => !selectedTags.contains(s))
                        .map(
                          (s) => GestureDetector(
                            onTap: () => setDlgState(() => selectedTags.add(s)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.07)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '+ $s',
                                style: TextStyle(fontSize: 11, color: sc),
                              ),
                            ),
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
                  setState(() => _inRoom = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Create Room'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showJoinDialog(bool isDark) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        final tc = isDark ? Colors.white : const Color(0xFF0F172A);
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFF8FAFC),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _inRoom = true);
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
        );
      },
    );
  }
}

// ─── Sticky Progress Header ───────────────────────────────────────────────────
class _ProgressHeader extends StatelessWidget {
  final int step;
  final bool isDark;
  const _ProgressHeader({required this.step, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Room', 'Join or create'),
      ('Teammates', 'Find your team'),
      ('Finalize', 'Lock & chat'),
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = step > (i ~/ 2) + 1;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                color: done
                    ? AppTheme.primaryColor
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFFE2E8F0)),
              ),
            );
          }
          final idx = (i ~/ 2) + 1;
          final done = step > idx;
          final active = step == idx;
          return Column(
            children: [
              AnimatedContainer(
                duration: 200.ms,
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done
                      ? Colors.green
                      : (active
                            ? AppTheme.primaryColor
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : const Color(0xFFF1F5F9))),
                ),
                child: Center(
                  child: done
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Colors.white,
                        )
                      : Text(
                          '$idx',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: active
                                ? Colors.white
                                : (isDark
                                      ? Colors.white38
                                      : const Color(0xFF94A3B8)),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[idx - 1].$1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active
                      ? AppTheme.primaryColor
                      : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                ),
              ),
              Text(
                steps[idx - 1].$2,
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────
class _RCard extends StatelessWidget {
  final bool isDark, hover;
  final Widget child;
  const _RCard({required this.isDark, required this.child, this.hover = false});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFE2E8F0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle, btnLabel;
  final bool isDark;
  final VoidCallback onTap;
  const _ChoiceCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.btnLabel,
    required this.isDark,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: _RCard(
      isDark: isDark,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              btnLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

class _AiBanner extends StatelessWidget {
  final bool isDark;
  final String msg;
  const _AiBanner({required this.isDark, required this.msg});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFF3E8FF), Color(0xFFFCE7F3)],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE9D5FF)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Team Matching',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                msg,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _Chip(String label, Color color) => Container(
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

Widget _SkillBadge(String s, bool isDark) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
  decoration: BoxDecoration(
    color: isDark
        ? AppTheme.primaryColor.withValues(alpha: 0.12)
        : AppTheme.primaryColor.withValues(alpha: 0.07),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    s,
    style: const TextStyle(
      fontSize: 11,
      color: AppTheme.primaryColor,
      fontWeight: FontWeight.w500,
    ),
  ),
);

class _PBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PBtn(this.label, {required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}

class _GhostWideBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  const _GhostWideBtn(this.label, {required this.onTap, required this.isDark});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : const Color(0xFFE2E8F0),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white60 : const Color(0xFF64748B),
        ),
      ),
    ),
  );
}

class _GhostBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _GhostBtn(this.icon, {required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : const Color(0xFFE2E8F0),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isDark ? Colors.white60 : const Color(0xFF64748B),
          ),
          const SizedBox(width: 4),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    ),
  );
}

class _OutlineIconBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark, danger;
  final VoidCallback onTap;
  const _OutlineIconBtn(
    this.icon,
    this.label, {
    required this.isDark,
    required this.onTap,
    this.danger = false,
  });
  @override
  Widget build(BuildContext context) {
    final c = danger
        ? Colors.red
        : (isDark ? Colors.white60 : const Color(0xFF64748B));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: danger
              ? Colors.red.withValues(alpha: 0.06)
              : Colors.transparent,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : const Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: c),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: c)),
          ],
        ),
      ),
    );
  }
}

// ─── AI Insight Banner (Step 2) ───────────────────────────────────────────────
class _AiInsightBanner extends StatelessWidget {
  final bool isDark;
  final int roomCount;
  const _AiInsightBanner({required this.isDark, required this.roomCount});
  @override
  Widget build(BuildContext context) {
    final sc = isDark ? Colors.white60 : const Color(0xFF64748B);
    const skills = ['Flutter', 'Firebase', 'Python'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E8FF), Color(0xFFFCE7F3)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Insight',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Based on your skills in',
                      style: TextStyle(fontSize: 12, color: sc),
                    ),
                    ...skills.map(
                      (s) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          s,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '— we found $roomCount teams that could use your expertise!',
                      style: TextStyle(fontSize: 12, color: sc),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Collab Category Badge ─────────────────────────────────────────────────────
Widget _CollabCategoryBadge(String type) {
  final Map<String, (Color, Color)> palette = {
    'Project': (const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
    'Research': (const Color(0xFF8B5CF6), const Color(0xFFF3E8FF)),
    'Collab': (const Color(0xFF14B8A6), const Color(0xFFCCFBF1)),
    'Study': (const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
  };
  final (Color textColor, Color bgColor) =
      palette[type] ?? (const Color(0xFF64748B), const Color(0xFFF1F5F9));
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      type,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    ),
  );
}

// ─── AI Candidate Row ──────────────────────────────────────────────────────────
class _AiCandidateRow extends StatelessWidget {
  final String name;
  final int pct;
  final bool isDark;
  const _AiCandidateRow({
    required this.name,
    required this.pct,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
            child: Text(
              name[0],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$pct% match',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Invite',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
