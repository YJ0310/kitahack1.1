import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildHeroSection(context)),
          SliverToBoxAdapter(child: _buildFeaturesSection(context)),
          SliverToBoxAdapter(child: _buildFooter(context)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor.withValues(alpha: 0.9),
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.hub_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'Teh Ais',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      actions: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, child) {
            final isDark = currentMode == ThemeMode.dark;
            return IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              color: AppTheme.primaryColor,
              onPressed: () {
                themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
              },
            );
          },
        ),
        const SizedBox(width: 8),
        TextButton(onPressed: () {}, child: const Text('About')),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => context.go('/login'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Sign In'),
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: size.width > 800 ? size.width * 0.1 : 24,
        vertical: 80,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Bridging Disciplines, Empowering Innovation',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              .animate()
              .fade(duration: 500.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 24),
          Text(
                'The Ultimate Cross-Disciplinary\nTalent Platform',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(height: 1.2),
              )
              .animate()
              .fade(delay: 200.ms, duration: 600.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 24),
          Text(
                'Connect with peers across faculties, discover events, and form the perfect team for your next big project or hackathon.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.normal,
                ),
              )
              .animate()
              .fade(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 48),
          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                    ),
                    child: const Text('Join the Network'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                    ),
                    child: const Text('Explore Events'),
                  ),
                ],
              )
              .animate()
              .fade(delay: 600.ms, duration: 500.ms)
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
              ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width > 800 ? size.width * 0.1 : 24,
        vertical: 64,
      ),
      child: Column(
        children: [
          Text(
            'Why Teh Ais?',
            style: Theme.of(context).textTheme.displayMedium,
          ).animate().fade().slideY(),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 700;
              final double cardWidth = isDesktop
                  ? (constraints.maxWidth - 24) / 2
                  : constraints.maxWidth;

              final features = [
                SizedBox(
                  width: cardWidth,
                  child: const _FeatureCard(
                    icon: Icons.group_add_rounded,
                    title: 'Smart Team Pairing',
                    description:
                        'Automatically find teammates with complementary skills for assignments and hackathons based on profile tags.',
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const _FeatureCard(
                    icon: Icons.event_available_rounded,
                    title: 'Targeted Events',
                    description:
                        'Discover events tailored to your interests and specific development goals directly on campus.',
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const _FeatureCard(
                    icon: Icons.insights_rounded,
                    title: 'Skill Development',
                    description:
                        'Track your growth from "interested to learn" to "mastered" through real-world collaborations.',
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const _FeatureCard(
                    icon: Icons.business_center_rounded,
                    title: 'Enterprise Connections',
                    description:
                        'Showcase your skills directly to hiring companies and find exclusive scholarship opportunities.',
                    color: Colors.purple,
                  ),
                ),
              ];

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: features.asMap().entries.map((entry) {
                  return entry.value
                      .animate()
                      .fade(delay: (200 * entry.key).ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: AppTheme.textPrimaryColor,
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Text(
          '© 2026 Teh Ais. Developed for Kitahack.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final MaterialColor color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? color.shade900.withValues(alpha: 0.5)
              : color.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.05 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? color.shade900.withValues(alpha: 0.4)
                  : color.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color.shade600, size: 32),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
