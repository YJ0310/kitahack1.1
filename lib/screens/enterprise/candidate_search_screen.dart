import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class CandidateSearchScreen extends StatefulWidget {
  const CandidateSearchScreen({super.key});
  @override
  State<CandidateSearchScreen> createState() => _CandidateSearchScreenState();
}

class _CandidateSearchScreenState extends State<CandidateSearchScreen> {
  String _query = '';
  String _filter = 'all';
  List<Map<String, dynamic>> _candidates = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCandidates();
  }

  Future<void> _fetchCandidates() async {
    try {
      final results = await ApiService().smartSearch('all candidates');
      _candidates = results.map<Map<String, dynamic>>((c) {
        final m = Map<String, dynamic>.from(c);
        return {
          'name': m['name'] ?? 'Candidate',
          'faculty': m['faculty'] ?? m['major'] ?? '',
          'match': m['score'] ?? m['matchPct'] ?? 80,
          'tags': List<String>.from(m['skills'] ?? m['tags'] ?? []),
          'gpa': m['gpa'] ?? 'N/A',
        };
      }).toList();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  List<Map<String, dynamic>> get _filtered {
    return _candidates.where((c) {
      final matchQ =
          _query.isEmpty ||
          (c['name'] as String).toLowerCase().contains(_query.toLowerCase()) ||
          (c['tags'] as List).any(
            (t) => (t as String).toLowerCase().contains(_query.toLowerCase()),
          );
      final matchF =
          _filter == 'all' ||
          (c['faculty'] as String).toLowerCase().contains(
            _filter.toLowerCase(),
          );
      return matchQ && matchF;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Candidate Search',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.textPrimaryColor,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 4),
            Text(
              'Find the perfect candidates using semantic search and AI tagging.',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : AppTheme.primaryColor.withValues(alpha: 0.6),
              ),
            ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
            const SizedBox(height: 20),
            // Search bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppTheme.backgroundColor.withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'e.g. "Python developer with finance background"',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : AppTheme.primaryColor.withValues(alpha: 0.4),
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : AppTheme.primaryColor.withValues(alpha: 0.5),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : AppTheme.backgroundColor.withValues(alpha: 0.3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                                'all',
                                'Computer Science',
                                'Engineering',
                                'Data Science',
                                'Business',
                              ]
                              .map(
                                (f) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _filter = f),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: _filter == f
                                            ? const LinearGradient(
                                                colors: [
                                                  Colors.purple,
                                                  Colors.deepPurple,
                                                ],
                                              )
                                            : null,
                                        color: _filter == f
                                            ? null
                                            : (isDark
                                                  ? Colors.white.withValues(
                                                      alpha: 0.06,
                                                    )
                                                  : AppTheme.backgroundColor
                                                        .withValues(
                                                          alpha: 0.5,
                                                        )),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        f == 'all' ? 'All Faculties' : f,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _filter == f
                                              ? Colors.white
                                              : (isDark
                                                    ? Colors.white.withValues(
                                                        alpha: 0.6,
                                                      )
                                                    : AppTheme.primaryColor
                                                          .withValues(
                                                            alpha: 0.7,
                                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 20),
            // Results
            Text(
              '${_filtered.length} candidates found',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.6)
                    : AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ..._filtered.asMap().entries.map(
              (e) => _CandidateCard(
                candidate: e.value,
                isDark: isDark,
                delay: e.key * 60,
              ),
            ),
            if (_filtered.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppTheme.primaryColor.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No candidates found',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final Map<String, dynamic> candidate;
  final bool isDark;
  final int delay;
  const _CandidateCard({
    required this.candidate,
    required this.isDark,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final tags = candidate['tags'] as List;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppTheme.backgroundColor.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.purple.withValues(alpha: 0.15),
              child: Text(
                (candidate['name'] as String)[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        candidate['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark
                              ? Colors.white
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${candidate['match']}% match',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${candidate['faculty']} • GPA: ${candidate['gpa']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppTheme.primaryColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: tags
                        .map(
                          (t) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              t as String,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
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
                  child: const Text('Invite'),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.purple.withValues(alpha: 0.3),
                    ),
                    foregroundColor: isDark ? Colors.white70 : Colors.purple,
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
                  child: const Text('Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
      delay: Duration(milliseconds: 150 + delay),
      duration: 400.ms,
    );
  }
}
