import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class EnterpriseNetworkScreen extends StatefulWidget {
  const EnterpriseNetworkScreen({super.key});

  @override
  State<EnterpriseNetworkScreen> createState() => _EnterpriseNetworkState();
}

class _EnterpriseNetworkState extends State<EnterpriseNetworkScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _enterprises = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final results = await ApiService().smartSearch('enterprise partners');
      _enterprises = results.map<Map<String, dynamic>>((c) {
        final m = Map<String, dynamic>.from(c);
        return {
          'name': m['name'] ?? 'Enterprise',
          'type': m['type'] ?? m['industry'] ?? 'Technology',
          'students': m['students'] ?? 0,
          'status': m['status'] ?? 'Active',
          'events': m['events'] ?? 0,
        };
      }).toList();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 900;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final enterprises = _enterprises;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enterprise Network',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.textPrimaryColor,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 4),
            Text(
              'Manage partnerships with enterprise organizations',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : AppTheme.primaryColor.withValues(alpha: 0.6),
              ),
            ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
            const SizedBox(height: 20),
            // Summary
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isWide ? 3 : 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: isWide ? 2.5 : 1.8,
              children: [
                _MiniStat(
                  icon: Icons.business_rounded,
                  label: 'Total Partners',
                  value: '${enterprises.length}',
                  color: Colors.teal,
                  isDark: isDark,
                ),
                _MiniStat(
                  icon: Icons.check_circle_rounded,
                  label: 'Active',
                  value:
                      '${enterprises.where((e) => e['status'] == 'Active').length}',
                  color: Colors.green,
                  isDark: isDark,
                ),
                _MiniStat(
                  icon: Icons.people_rounded,
                  label: 'Students Placed',
                  value: '${enterprises.fold<int>(0, (s, e) => s + ((e['students'] as int?) ?? 0))}',
                  color: Colors.blue,
                  isDark: isDark,
                ),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 24),
            // Partners List
            ...enterprises.asMap().entries.map((e) {
              final p = e.value;
              final isActive = p['status'] == 'Active';
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
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.teal.withValues(alpha: 0.15),
                        child: Text(
                          (p['name'] as String)[0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['name'] as String,
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
                              '${p['type']} • ${p['students']} students • ${p['events']} events',
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isActive ? Colors.green : Colors.orange)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          p['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          'View',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.teal.withValues(alpha: 0.3),
                          ),
                          foregroundColor: isDark
                              ? Colors.white70
                              : Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(
                delay: Duration(milliseconds: 150 + e.key * 60),
                duration: 400.ms,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final bool isDark;
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : AppTheme.primaryColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
