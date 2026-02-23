import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:go_router/go_router.dart';

// Dummy Model for UI
class EventModel {
  final String title;
  final String date;
  final String location;
  final List<String> tags;
  final MaterialColor color;
  final bool isTeamRequired;
  final bool isRecommended;

  EventModel({
    required this.title,
    required this.date,
    required this.location,
    required this.tags,
    required this.color,
    required this.isTeamRequired,
    this.isRecommended = false,
  });
}

class StudentEventScreen extends StatefulWidget {
  const StudentEventScreen({super.key});

  @override
  State<StudentEventScreen> createState() => _StudentEventScreenState();
}

class _StudentEventScreenState extends State<StudentEventScreen> {
  // Simulated Server Data Fetch
  final List<EventModel> _allEvents = [
    EventModel(
      title: 'UM Hackathon 2026',
      date: 'Nov 12 - Nov 14',
      location: 'Faculty of Computer Science',
      tags: ['Competition', 'Programming', 'Prize Pool'],
      color: Colors.purple,
      isTeamRequired: true,
      isRecommended: true,
    ),
    EventModel(
      title: 'Data Science Industry Talk',
      date: 'Nov 10, 2:00 PM',
      location: 'Online / Zoom',
      tags: ['Talk/Seminar', 'Industry Insights'],
      color: Colors.blue,
      isTeamRequired: false,
      isRecommended: true,
    ),
    EventModel(
      title: 'Annual Tech Symposium',
      date: 'Dec 1, 9:00 AM',
      location: 'Main Hall',
      tags: const ['Event Committee', 'Logistics Role'],
      color: Colors.orange,
      isTeamRequired: false,
      isRecommended: true,
    ),
    EventModel(
      title: 'Design Thinking Workshop',
      date: 'Dec 5, 10:00 AM',
      location: 'FBA Building',
      tags: const ['Workshop', 'UI/UX'],
      color: Colors.pink,
      isTeamRequired: true,
      isRecommended: false,
    ),
    EventModel(
      title: 'Cybersecurity CTF',
      date: 'Dec 15, 8:00 AM',
      location: 'Lab 3',
      tags: const ['Competition', 'Security'],
      color: Colors.green,
      isTeamRequired: true,
      isRecommended: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final recommendedEvents = _allEvents.where((e) => e.isRecommended).toList();
    final allServerEvents = _allEvents.where((e) => !e.isRecommended).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

            // Recommended Section
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 12),
                Text(
                  'Recommended For You',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: recommendedEvents
                  .map((e) => _EventCard(event: e))
                  .toList(),
            ),

            const SizedBox(height: 64),

            // All Events Section
            Row(
              children: [
                const Icon(Icons.explore, color: AppTheme.secondaryColor),
                const SizedBox(width: 12),
                Text(
                  'Explore Entire Server',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: allServerEvents
                  .map((e) => _EventCard(event: e))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    // Check if Dark Theme is active
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? event.color.shade900 : event.color.shade100,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? event.color.shade900.withValues(alpha: 0.4)
                  : event.color.shade50,
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
                      color: isDark
                          ? event.color.shade300
                          : event.color.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.date,
                      style: TextStyle(
                        color: isDark
                            ? event.color.shade300
                            : event.color.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.title,
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
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: event.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade900
                                : Colors.grey.shade100,
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
                    onPressed: () {
                      if (event.isTeamRequired) {
                        // Navigate to Team Screen to create a room
                        context.go('/student/teams');
                      } else {
                        // Join logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Joined successfully!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: event.color.shade600,
                    ),
                    child: Text(
                      event.isTeamRequired
                          ? 'Create Room (Team Required)'
                          : 'Join Event',
                    ),
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
