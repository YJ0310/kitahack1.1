import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class PublishContentScreen extends StatefulWidget {
  const PublishContentScreen({super.key});
  @override
  State<PublishContentScreen> createState() => _PublishContentScreenState();
}

class _PublishContentScreenState extends State<PublishContentScreen> {
  String _selectedType = 'Event';
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _showForm = false;

  final _published = [
    {
      'title': 'Kitahack 2026 Registration',
      'type': 'Event',
      'date': 'Feb 20, 2026',
      'status': 'Active',
      'reach': '3,450',
    },
    {
      'title': 'Scholarship Applications Q2',
      'type': 'Announcement',
      'date': 'Feb 18, 2026',
      'status': 'Active',
      'reach': '2,100',
    },
    {
      'title': 'Flutter Workshop Series',
      'type': 'Workshop',
      'date': 'Feb 15, 2026',
      'status': 'Ended',
      'reach': '890',
    },
    {
      'title': 'Career Fair 2026',
      'type': 'Event',
      'date': 'Feb 10, 2026',
      'status': 'Upcoming',
      'reach': '5,200',
    },
  ];

  Color _typeColor(String t) {
    switch (t) {
      case 'Event':
        return Colors.orange;
      case 'Workshop':
        return Colors.purple;
      case 'Announcement':
        return Colors.blue;
      default:
        return Colors.teal;
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Active':
        return Colors.green;
      case 'Ended':
        return Colors.grey;
      case 'Upcoming':
        return Colors.blue;
      default:
        return Colors.teal;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
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
                            'Publish Content',
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
                            'Create and manage events, announcements, and workshops',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _showForm = true),
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('New Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Published list
                ..._published.asMap().entries.map((e) {
                  final p = e.value;
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
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _typeColor(
                                p['type']!,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              p['type'] == 'Event'
                                  ? Icons.event_rounded
                                  : p['type'] == 'Workshop'
                                  ? Icons.build_rounded
                                  : Icons.campaign_rounded,
                              size: 18,
                              color: _typeColor(p['type']!),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p['title']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white
                                        : AppTheme.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${p['type']} • ${p['date']}',
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(
                                    p['status']!,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  p['status']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(p['status']!),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${p['reach']} reach',
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
                        ],
                      ),
                    ),
                  ).animate().fadeIn(
                    delay: Duration(milliseconds: 100 + e.key * 60),
                    duration: 400.ms,
                  );
                }),
              ],
            ),
          ),
          // Create Post Dialog
          if (_showForm)
            GestureDetector(
              onTap: () => setState(() => _showForm = false),
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.teal, Color(0xFF00897B)],
                                ),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.publish_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      'Create New Post',
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
                                    onPressed: () =>
                                        setState(() => _showForm = false),
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
                                  _label('Type', isDark),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: ['Event', 'Workshop', 'Announcement']
                                        .map(
                                          (t) => Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: GestureDetector(
                                              onTap: () => setState(
                                                () => _selectedType = t,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient: _selectedType == t
                                                      ? const LinearGradient(
                                                          colors: [
                                                            Colors.teal,
                                                            Color(0xFF00897B),
                                                          ],
                                                        )
                                                      : null,
                                                  color: _selectedType == t
                                                      ? null
                                                      : (isDark
                                                            ? Colors.white
                                                                  .withValues(
                                                                    alpha: 0.06,
                                                                  )
                                                            : AppTheme
                                                                  .backgroundColor
                                                                  .withValues(
                                                                    alpha: 0.5,
                                                                  )),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  t,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: _selectedType == t
                                                        ? Colors.white
                                                        : (isDark
                                                              ? Colors.white70
                                                              : AppTheme
                                                                    .primaryColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  const SizedBox(height: 14),
                                  _label('Title', isDark),
                                  const SizedBox(height: 6),
                                  _field(_titleCtrl, 'Enter title…', isDark),
                                  const SizedBox(height: 14),
                                  _label('Description', isDark),
                                  const SizedBox(height: 6),
                                  _field(
                                    _descCtrl,
                                    'Enter description…',
                                    isDark,
                                    lines: 3,
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          setState(() => _showForm = false),
                                      icon: const Icon(
                                        Icons.publish_rounded,
                                        size: 16,
                                      ),
                                      label: const Text('Publish'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
            ),
        ],
      ),
    );
  }

  Widget _label(String t, bool isDark) => Text(
    t,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: isDark
          ? Colors.white.withValues(alpha: 0.6)
          : AppTheme.primaryColor.withValues(alpha: 0.7),
    ),
  );

  Widget _field(
    TextEditingController c,
    String hint,
    bool isDark, {
    int lines = 1,
  }) => TextField(
    controller: c,
    maxLines: lines,
    style: TextStyle(
      fontSize: 13,
      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
    ),
    decoration: InputDecoration(
      hintText: hint,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    ),
  );
}
