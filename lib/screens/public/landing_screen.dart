import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
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
      backgroundColor: Colors.white.withValues(alpha: 0.9),
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
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          ),
          const SizedBox(height: 24),
          Text(
            'The Ultimate Cross-Disciplinary\nTalent Platform',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(height: 1.2),
          ),
          const SizedBox(height: 24),
          Text(
            'Connect with peers across faculties, discover events, and form the perfect team for your next big project or hackathon.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.normal,
            ),
          ),
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
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 700;
              final double cardWidth = isDesktop
                  ? (constraints.maxWidth - 24) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
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
                ],
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
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
              color: color.shade50,
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
