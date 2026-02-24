import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // Managing expanded state of group tags
  final List<bool> _isExpanded = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile & Tagging',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sync),
                  label: const Text('Fetch via Spectrum (UM LMS)'),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Course Tags
            const Text(
              'Course Tagging (Fixed)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Your verified courses from your academic major.'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSimpleTag(
                  'WQD10101 Programming 1',
                  AppTheme.textSecondaryColor,
                ),
                _buildSimpleTag(
                  'WQD10102 Data Structure',
                  AppTheme.textSecondaryColor,
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Group Skills Tags
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advanced Skills Tagging (Mastered)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Skills verified via events or courses, grouped by domain for massive scalability.',
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add Group'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ExpansionPanelList(
                elevation: 0,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded[index] = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    isExpanded: _isExpanded[0],
                    canTapOnHeader: true,
                    backgroundColor: Theme.of(context).cardTheme.color,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(
                        leading: Icon(
                          Icons.memory,
                          color: AppTheme.primaryColor,
                        ),
                        title: Text(
                          'Machine Learning & AI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '14 Specific Tags',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildSimpleTag(
                            'Scikit-learn',
                            AppTheme.secondaryColor,
                          ),
                          _buildSimpleTag(
                            'TensorFlow',
                            AppTheme.secondaryColor,
                          ),
                          _buildSimpleTag(
                            'Transformers',
                            AppTheme.secondaryColor,
                          ),
                          _buildSimpleTag('CNN', AppTheme.secondaryColor),
                          _buildSimpleTag('ANN', AppTheme.secondaryColor),
                          _buildSimpleTag('RNN', AppTheme.secondaryColor),
                          _buildSimpleTag('K-Means', AppTheme.secondaryColor),
                          _buildSimpleTag(
                            'Random Forest',
                            AppTheme.secondaryColor,
                          ),
                          _buildSimpleTag('NLP', AppTheme.secondaryColor),
                          _buildSimpleTag(
                            'Computer Vision',
                            AppTheme.secondaryColor,
                          ),
                          _buildSimpleTag(
                            'Stable Diffusion',
                            AppTheme.secondaryColor,
                          ),
                          _buildSimpleTag('PyTorch', AppTheme.secondaryColor),
                          _buildSimpleTag(
                            'Deep Learning',
                            AppTheme.secondaryColor,
                          ),
                          _buildSimpleTag(
                            'Reinforcement L.',
                            AppTheme.secondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ExpansionPanel(
                    isExpanded: _isExpanded[1],
                    canTapOnHeader: true,
                    backgroundColor: Theme.of(context).cardTheme.color,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(
                        leading: Icon(Icons.code, color: AppTheme.accentOrange),
                        title: Text(
                          'Backend Development',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '6 Specific Tags',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildSimpleTag('Python', AppTheme.accentOrange),
                          _buildSimpleTag('FastAPI', AppTheme.accentOrange),
                          _buildSimpleTag('Django', AppTheme.accentOrange),
                          _buildSimpleTag('PostgreSQL', AppTheme.accentOrange),
                          _buildSimpleTag('Redis', AppTheme.accentOrange),
                          _buildSimpleTag('Docker', AppTheme.accentOrange),
                        ],
                      ),
                    ),
                  ),
                  ExpansionPanel(
                    isExpanded: _isExpanded[2],
                    canTapOnHeader: true,
                    backgroundColor: Theme.of(context).cardTheme.color,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(
                        leading: Icon(
                          Icons.analytics,
                          color: AppTheme.accentPurple,
                        ),
                        title: Text(
                          'Data Analytics',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '4 Specific Tags',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildSimpleTag('Pandas', AppTheme.accentPurple),
                          _buildSimpleTag('NumPy', AppTheme.accentPurple),
                          _buildSimpleTag('Tableau', AppTheme.accentPurple),
                          _buildSimpleTag('SQL', AppTheme.accentPurple),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Development Tags
            const Text(
              'Development Tagging (Learning)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Areas you are interested in. The system will find suitable events/courses to turn these into Skills.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSimpleTag('Financial Modeling', AppTheme.accentPink),
                _buildSimpleTag('Cloud Architecture', AppTheme.accentPink),
                _buildSimpleTag(
                  '+ Add Learning Domain',
                  AppTheme.primaryColor,
                  isBorderOnly: true,
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Portfolio & Works
            const Text(
              'Portfolio & Works',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Projects, assignments, and hackathon links to demonstrate your capabilities to peers and enterprises.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                const _PortfolioCard(
                  title: 'Sentiment Analysis Bot',
                  description:
                      'Built a python-based scraper and sentiment analyzer for stock market predictions.',
                  associatedTags: ['Python', 'Data Analysis', 'Finance'],
                ),
                const _PortfolioCard(
                  title: 'UM Food Delivery Design',
                  description:
                      'Figma prototype for a localized food delivery app aimed at UM residential colleges.',
                  associatedTags: ['UI/UX Design', 'Figma'],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleTag(
    String label,
    Color color, {
    bool isBorderOnly = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isBorderOnly ? Colors.transparent : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: isBorderOnly
            ? Border.all(color: color, width: 1.5)
            : Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> associatedTags;

  const _PortfolioCard({
    required this.title,
    required this.description,
    required this.associatedTags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_special_rounded, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: associatedTags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.link),
            label: const Text('View Project'),
          ),
        ],
      ),
    );
  }
}
