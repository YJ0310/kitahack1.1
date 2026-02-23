import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StudentTeamScreen extends StatefulWidget {
  const StudentTeamScreen({super.key});

  @override
  State<StudentTeamScreen> createState() => _StudentTeamScreenState();
}

class _StudentTeamScreenState extends State<StudentTeamScreen> {
  bool _autoPairingEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Teams & Pairing',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Row(
                  children: [
                    const Text(
                      'AI Auto-Pairing Active',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _autoPairingEnabled,
                      activeColor: AppTheme.secondaryColor,
                      onChanged: (val) {
                        setState(() {
                          _autoPairingEnabled = val;
                        });
                        if (val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Auto-pairing enabled. You will be matched instantly.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Form your core group using invite codes, then let AI find the remaining perfect matches.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),

            // Pre-Group Invitation System
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                    AppTheme.secondaryColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_rounded,
                        color: AppTheme.primaryDarkColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Your Starting Pair (Core Group)',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryDarkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      // Self Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.primaryColor),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryColor
                                    .withValues(alpha: 0.2),
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alex Chen (You)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Flutter Developer',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Icon(
                          Icons.link_rounded,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
                      // Vacant / Invite Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.none,
                            ),
                          ), // Actually use dashed border in real app, simplified here
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                ),
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Invite Code Copied: TX-8492-AC',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Generate Invite Code',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Once you and your friend are paired, the system will use both your tags to match with other teams.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
            Text(
              'Your AI Match Results',
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
                      'They need Python & Data Vis. You have Mastered Python and have a tag for Data Vis.',
                  matchScore: 92,
                  onAction: () =>
                      _showJoinDialog(context, 'Quant Wizards', true),
                  isAccepted: false,
                ),
                _AIMatchCard(
                  teamName: 'EcoTech Innovators',
                  projectType: 'Smart Mechanical Design',
                  matchReason:
                      'You are looking for hardware experience. They are tracking "Programming (CS)".',
                  matchScore: 85,
                  onAction: () =>
                      _showJoinDialog(context, 'EcoTech Innovators', false),
                  isAccepted: true,
                ),
              ],
            ),
            const SizedBox(height: 48),
            Text(
              'Pending Requests',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded, color: Colors.orange),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'You sent a request to "DevOps Masters" 2 hours ago. Waiting for leader approval.',
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Cancel Request',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.publish_rounded),
        label: const Text('Publish Need/Requirement'),
      ),
    );
  }

  void _showJoinDialog(BuildContext context, String teamName, bool isSending) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isSending ? 'Request to Join $teamName?' : 'View $teamName Details',
        ),
        content: Text(
          isSending
              ? 'The AI suggests you are a great fit. Send an invite to the leader?'
              : 'Reviewing team details...',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSending
                        ? 'Request sent successfully.'
                        : 'Details loading...',
                  ),
                ),
              );
            },
            child: Text(isSending ? 'Send Request' : 'Okay'),
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
  final VoidCallback onAction;
  final bool isAccepted;

  const _AIMatchCard({
    required this.teamName,
    required this.projectType,
    required this.matchReason,
    required this.matchScore,
    required this.onAction,
    required this.isAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAccepted ? Colors.green.shade200 : Colors.blue.shade100,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                  color: isAccepted
                      ? Colors.green.shade50
                      : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: isAccepted
                          ? Colors.green.shade700
                          : Colors.purple.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$matchScore% Match',
                      style: TextStyle(
                        color: isAccepted
                            ? Colors.green.shade700
                            : Colors.purple.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            style: const TextStyle(
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAccepted ? Colors.green : Colors.blue,
              ),
              child: Text(
                isAccepted
                    ? 'Already Paired (View Team)'
                    : 'Accept Match & Send Request',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
