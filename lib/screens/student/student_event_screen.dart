import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StudentEventScreen extends StatelessWidget {
  const StudentEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Events & Competitions',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Curated events based on your Development and Skills tagging.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),

            Text(
              'Recommended For You',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                const _EventCard(
                  title: 'UM Hackathon 2026',
                  date: 'Nov 12 - Nov 14',
                  location: 'Faculty of Computer Science',
                  tags: ['Competition', 'Programming', 'Prize Pool'],
                  color: Colors.purple,
                ),
                const _EventCard(
                  title: 'Data Science Industry Talk',
                  date: 'Nov 10, 2:00 PM',
                  location: 'Online / Zoom',
                  tags: ['Talk/Seminar', 'Industry Insights'],
                  color: Colors.blue,
                ),
                _EventCard(
                  title: 'Annual Tech Symposium',
                  date: 'Dec 1, 9:00 AM',
                  location: 'Main Hall',
                  tags: const ['Event Committee', 'Logistics Role'],
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final List<String> tags;
  final MaterialColor color;

  const _EventCard({
    required this.title,
    required this.date,
    required this.location,
    required this.tags,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.shade100, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: color.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(
                        color: color.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.shade600,
                    ),
                    child: const Text('Register'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
