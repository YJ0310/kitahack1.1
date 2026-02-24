import 'package:flutter/material.dart';

class CandidateSearchScreen extends StatelessWidget {
  const CandidateSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Candidate Search',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Find the perfect candidates using semantic search and AI tagging.',
            ),
            const SizedBox(height: 48),

            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., "Python developer with finance background"',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  child: const Text('Search'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 48),

            Text('Top Matches', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),

            const _CandidateCard(
              name: 'Alex Lee',
              faculty: 'IT & Business',
              matchScore: '98%',
              tags: ['Python', 'Financial Modeling', 'Data Visualization'],
            ),
            const SizedBox(height: 16),
            const _CandidateCard(
              name: 'Sarah Rahman',
              faculty: 'Computer Science',
              matchScore: '85%',
              tags: ['Flutter', 'Firebase', 'UI/UX'],
            ),
          ],
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final String name;
  final String faculty;
  final String matchScore;
  final List<String> tags;

  const _CandidateCard({
    required this.name,
    required this.faculty,
    required this.matchScore,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple.shade100,
            child: Text(
              name[0],
              style: TextStyle(
                color: Colors.purple.shade800,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
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
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$matchScore Match',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(faculty, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: tags
                      .map(
                        (t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 12)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          ElevatedButton(onPressed: () {}, child: const Text('Invite')),
        ],
      ),
    );
  }
}
