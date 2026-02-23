import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:flutter/services.dart';

class StudentTeamScreen extends StatefulWidget {
  const StudentTeamScreen({super.key});

  @override
  State<StudentTeamScreen> createState() => _StudentTeamScreenState();
}

class _StudentTeamScreenState extends State<StudentTeamScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State variables for the complex logic
  int _roomMembers = 1;
  int _maxRoomMembers = 4;
  bool _isAIPoolActive = false;
  String _inviteCode = "KH-8492-AC";

  // Group Chat Creation State
  bool _isTeamFormed = false; // When room combines to reach max members
  bool _isCreatingGroup = false;
  int _countdownSeconds = 180;
  String _groupLinkError = "";
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCreatingGroup = true;
      _countdownSeconds = 180;
    });

    // Simulate countdown (in a real app, use a Timer)
    Future.delayed(const Duration(seconds: 1), _decrementTimer);
  }

  void _decrementTimer() {
    if (!mounted) return;
    if (_countdownSeconds > 0 && _isCreatingGroup) {
      setState(() {
        _countdownSeconds--;
      });
      Future.delayed(const Duration(seconds: 1), _decrementTimer);
    } else if (_countdownSeconds == 0) {
      // Auto fail when time runs out
      setState(() {
        _isCreatingGroup = false;
        _groupLinkError =
            "Time expired. Someone else can attempt to create the group.";
      });
    }
  }

  void _validateAndSubmitLink() {
    final link = _linkController.text.trim();
    // Basic regex for common group chat links
    final isValid = RegExp(
      r'^(https?:\/\/)?(chat\.whatsapp\.com|t\.me|discord\.gg)\/.*$',
    ).hasMatch(link);

    if (isValid) {
      setState(() {
        _isCreatingGroup = false;
        _groupLinkError = "";
        // In real app, save to backend here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group chat linked successfully!')),
        );
      });
    } else {
      setState(() {
        _groupLinkError =
            "Invalid link format. Must be WhatsApp, Telegram, or Discord.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Teams & Pairing',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppTheme.primaryColor,
                  tabs: const [
                    Tab(text: "My Room"),
                    Tab(text: "Suggested Rooms"),
                    Tab(text: "My Team"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyRoomTab(),
                _buildSuggestedTab(),
                _buildMyTeamTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRoomTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pre-Team Room Phase',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _roomMembers = 4;
                    _isTeamFormed = true;
                    _tabController.animateTo(2); // Jump to Team tab for demo
                  });
                },
                icon: const Icon(Icons.fast_forward),
                label: const Text('Dev: Force Form Team'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Form your core group using invite codes, then let AI find the remaining perfect matches. You are currently the temporary lead.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // AI Hiring Pool Switch
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.secondaryColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Matchmaking Pool',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isAIPoolActive
                          ? 'Your room is currently visible to AI for pairing.'
                          : 'Turn on to let AI find suitable members or rooms to merge with.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Switch(
                  value: _isAIPoolActive,
                  activeColor: AppTheme.secondaryColor,
                  onChanged: (val) {
                    setState(() {
                      _isAIPoolActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Core Group UI
          Text(
            'Room Members ($_roomMembers/$_maxRoomMembers)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMemberCard(
                name: 'You (Temp Lead)',
                role: 'Flutter Dev',
                isLead: true,
              ),
              const SizedBox(width: 24),
              _buildInviteCard(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Recommended Rooms to Join',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _AIMatchCard(
                teamName: 'Quant Wizards',
                projectType: 'Financial Data Analysis',
                matchReason:
                    'They need Python & Data Vis. You have Mastered Python.',
                matchScore: 92,
                membersCount: 2,
              ),
              _AIMatchCard(
                teamName: 'EcoTech Innovators',
                projectType: 'Smart Mechanical Design',
                matchReason: 'They are looking for cross-faculty members.',
                matchScore: 85,
                membersCount: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyTeamTab() {
    if (!_isTeamFormed) {
      return const Center(
        child: Text(
          'Your room has not reached the max members yet to form a team.',
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.primaryColor),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Team Formed! There are no leaders anymore. All members have equal voting rights.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Group Chat Creation Logic
          _buildGroupChatSection(),

          const SizedBox(height: 48),
          Text(
            'Team Roster (4/4)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _buildMemberCard(name: 'You', role: 'Flutter Dev', isLead: false),
              _buildMemberCard(
                name: 'Sarah Jane',
                role: 'UI/UX Designer',
                isLead: false,
              ),
              _buildMemberCard(name: 'Michael', role: 'Backend', isLead: false),
              _buildMemberCard(
                name: 'David',
                role: 'Data Analyst',
                isLead: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupChatSection() {
    if (_isCreatingGroup) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create External Group Chat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Time Remaining: $_countdownSeconds s',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Click an icon below to open the app and create a group.\n2. Paste the join link here before the timer runs out.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble, color: Colors.green),
                  onSize: 48,
                  onPressed: () {
                    // Redirect logic here
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onSize: 48,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.discord, color: Colors.indigo),
                  onSize: 48,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                hintText: 'Paste invite link here (e.g. chat.whatsapp.com/...)',
                errorText: _groupLinkError.isEmpty ? null : _groupLinkError,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _validateAndSubmitLink,
              child: const Text('Complete & Link Group'),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'No external group chat linked yet!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Only the first person to click the button below can create the link.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            if (_groupLinkError.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_groupLinkError, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startCountdown,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('I will create the Group Chat'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMemberCard({
    required String name,
    required String role,
    required bool isLead,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLead
              ? AppTheme.primaryColor
              : Theme.of(context).dividerColor,
          width: isLead ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            child: const Icon(Icons.person, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(role, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInviteCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade600,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.person_outline, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vacant Slot',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _inviteCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invite Code Copied: $_inviteCode')),
                  );
                },
                child: const Text(
                  'Copy Invite Code',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AIMatchCard extends StatelessWidget {
  final String teamName;
  final String projectType;
  final String matchReason;
  final int matchScore;
  final int membersCount;

  const _AIMatchCard({
    required this.teamName,
    required this.projectType,
    required this.matchReason,
    required this.matchScore,
    required this.membersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                teamName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$matchScore% Match',
                  style: TextStyle(
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$membersCount/4 Members Current',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Project Type:',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          Text(projectType),
          const SizedBox(height: 12),
          const Text(
            'AI Match Reason:',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          Text(
            matchReason,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Send Join Request'),
            ),
          ),
        ],
      ),
    );
  }
}
