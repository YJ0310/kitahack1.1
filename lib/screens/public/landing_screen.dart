import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../main.dart'; // Access to themeNotifier

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: _buildNavBar(isDark),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _HeroSection(),
            _FeaturesSection(),
            _HowItWorksSection(),
            _CTASection(),
            _Footer(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildNavBar(bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: _isScrolled
            ? (isDark
                  ? AppTheme.textPrimaryColor.withValues(alpha: 0.9)
                  : AppTheme.surfaceColor.withValues(alpha: 0.9))
            : Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryDarkColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/favicon.ico',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Teh Ais',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.backgroundColor
                            : AppTheme.primaryDarkColor,
                      ),
                    ),
                  ],
                ),
                // Desktop Navigation Actions
                if (MediaQuery.of(context).size.width > 800)
                  Row(
                    children: [
                      _NavTextButton('Features'),
                      _NavTextButton('How It Works'),
                      _NavTextButton('About'),
                      const SizedBox(width: 16),
                      _ThemeToggle(),
                      const SizedBox(width: 16),
                      ElevatedButton(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Join Now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(duration: 2.seconds, color: Colors.white24),
                    ],
                  )
                else
                  Row(
                    children: [
                      _ThemeToggle(),
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: isDark
                              ? AppTheme.backgroundColor
                              : AppTheme.primaryDarkColor,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTextButton extends StatelessWidget {
  final String title;
  const _NavTextButton(this.title);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: isDark
            ? AppTheme.backgroundColor.withValues(alpha: 0.8)
            : AppTheme.primaryColor,
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          color: isDark ? AppTheme.backgroundColor : AppTheme.primaryColor,
          style: IconButton.styleFrom(
            backgroundColor: isDark
                ? AppTheme.backgroundColor.withValues(alpha: 0.2)
                : AppTheme.primaryColor.withValues(alpha: 0.1),
          ),
          onPressed: () {
            themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
          },
        );
      },
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 800),
      // Mimicking the complex CSS background gradients
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Stack(
        children: [
          // Background blurry blobs mimicking React version
          Positioned(
            top: 100,
            right: 50,
            child:
                Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppTheme.primaryColor.withValues(alpha: 0.2)
                            : AppTheme.backgroundColor.withValues(alpha: 0.5),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(
                      begin: 1.0,
                      end: 1.2,
                      duration: 4.seconds,
                      curve: Curves.easeInOut,
                    )
                    .blur(begin: const Offset(0, 0), end: const Offset(60, 60)),
          ),
          Positioned(
            bottom: 150,
            left: 50,
            child:
                Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppTheme.secondaryColor.withValues(alpha: 0.1)
                            : AppTheme.secondaryColor.withValues(alpha: 0.2),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(
                      begin: 1.0,
                      end: 1.1,
                      duration: 5.seconds,
                      curve: Curves.easeInOut,
                    )
                    .blur(begin: const Offset(0, 0), end: const Offset(80, 80)),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 80,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Badge
                          Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppTheme.backgroundColor.withValues(
                                          alpha: 0.1,
                                        )
                                      : AppTheme.primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? AppTheme.backgroundColor
                                                : AppTheme.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                        .animate(
                                          onPlay: (c) =>
                                              c.repeat(reverse: true),
                                        )
                                        .scaleXY(end: 1.5, duration: 800.ms),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Bridging Disciplines, Empowering Innovation',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? AppTheme.backgroundColor
                                            : AppTheme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 32),
                          // Main Title
                          RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontSize: width > 800 ? 72 : 48,
                                        height: 1.1,
                                      ),
                                  children: [
                                    const TextSpan(
                                      text: 'The Ultimate Cross-Disciplinary\n',
                                    ),
                                    TextSpan(
                                      text: 'Talent Platform',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppTheme.secondaryColor
                                            : AppTheme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 100.ms, duration: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 24),
                          // Subtitle
                          ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 700,
                                ),
                                child: Text(
                                  'Connect with peers across faculties, discover events, and form the perfect team — all before your Teh Ais melts! ☕',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontSize: width > 800 ? 20 : 16,
                                        color: isDark
                                            ? AppTheme.backgroundColor
                                                  .withValues(alpha: 0.8)
                                            : AppTheme.primaryColor.withValues(
                                                alpha: 0.8,
                                              ),
                                      ),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 40),
                          // Buttons
                          Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => context.go('/login'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 5,
                                    ),
                                    label: const Text(
                                      "Start Connecting",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    icon: const Icon(Icons.arrow_forward),
                                  ),
                                  const SizedBox(width: 16),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: isDark
                                          ? AppTheme.backgroundColor
                                          : AppTheme.primaryColor,
                                      side: BorderSide(
                                        color: isDark
                                            ? AppTheme.backgroundColor
                                            : AppTheme.primaryColor,
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Explore Events",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 64),
                          // Stats
                          Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _StatItem("5min", "Avg. Match Time"),
                                  const SizedBox(width: 48),
                                  _StatItem("1000+", "Teams Formed"),
                                  const SizedBox(width: 48),
                                  _StatItem("50+", "Events Monthly"),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                    if (width > 1200)
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child:
                              Container(
                                    width: 250,
                                    height: 250,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 40,
                                          offset: Offset(0, 20),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/favicon.ico',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                  .animate(
                                    onPlay: (c) => c.repeat(reverse: true),
                                  )
                                  .moveY(
                                    begin: -15,
                                    end: 15,
                                    duration: 3.seconds,
                                    curve: Curves.easeInOut,
                                  ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppTheme.backgroundColor
                : AppTheme.primaryDarkColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? AppTheme.backgroundColor.withValues(alpha: 0.6)
                : AppTheme.primaryColor.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      'icon': Icons.group,
      'title': "Smart Team Pairing",
      'desc':
          "Automatically find teammates with complementary skills based on profile tags and interests.",
    },
    {
      'icon': Icons.calendar_today,
      'title': "Targeted Events",
      'desc':
          "Discover events tailored to your interests and development goals directly on campus.",
    },
    {
      'icon': Icons.bolt,
      'title': "Skill Development",
      'desc':
          "Track your growth from \"interested\" to \"mastered\" through real-world collaborations.",
    },
    {
      'icon': Icons.emoji_events,
      'title': "Enterprise Connections",
      'desc':
          "Showcase your skills to hiring companies and find scholarship opportunities.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141414) : Colors.white,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                "Why Teh Ais?",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                "Because great things happen over a refreshing drink. Here's how we help you connect faster.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppTheme.backgroundColor.withValues(alpha: 0.6)
                      : AppTheme.primaryColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 64),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: List.generate(
                  features.length,
                  (index) => _FeatureCard(
                    icon: features[index]['icon'],
                    title: features[index]['title'],
                    description: features[index]['desc'],
                    delayMs: (index + 1) * 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delayMs;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
          width: 280,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark
                ? AppTheme.textPrimaryColor.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? AppTheme.primaryColor.withValues(alpha: 0.3)
                  : AppTheme.backgroundColor.withValues(alpha: 0.3),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.backgroundColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  color: isDark
                      ? AppTheme.backgroundColor.withValues(alpha: 0.7)
                      : AppTheme.primaryColor.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: delayMs.ms, duration: 500.ms)
        .slideY(begin: 0.1, end: 0);
  }
}

class _HowItWorksSection extends StatelessWidget {
  final List<Map<String, String>> steps = [
    {
      "num": "01",
      "title": "Create Profile",
      "desc":
          "Set up your profile with skills, interests, and what you're looking to build.",
    },
    {
      "num": "02",
      "title": "Discover & Match",
      "desc":
          "Browse events or let our AI find the perfect collaborators for you.",
    },
    {
      "num": "03",
      "title": "Quick Connect",
      "desc": "Start a 5-minute chat session to see if there's a spark.",
    },
    {
      "num": "04",
      "title": "Build Together",
      "desc": "Form your dream team and start creating something amazing!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1a1a) : AppTheme.textPrimaryColor,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                "How It Works",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Four simple steps to go from solo to squad — faster than your ice melts.",
                style: TextStyle(
                  fontSize: 20,
                  color: AppTheme.backgroundColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 64),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: List.generate(
                  steps.length,
                  (index) =>
                      SizedBox(
                            width: 250,
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.primaryColor,
                                        AppTheme.secondaryColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      steps[index]["num"]!,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  steps[index]["title"]!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  steps[index]["desc"]!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.backgroundColor.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (index * 150).ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDarkColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/favicon.ico',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                  begin: -10,
                  end: 10,
                  duration: 2.seconds,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: 32),
            const Text(
              "Ready to Build Something Amazing?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Join thousands of students and professionals who are connecting, collaborating, and creating — all before their teh ais finishes.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryDarkColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  label: const Text(
                    "Join the Network",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Learn More",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.textPrimaryColor,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.primaryDarkColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/favicon.ico',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Teh Ais",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Connecting minds, building dreams — one sip at a time. The platform where collaboration happens at the speed of your favorite iced tea.",
                          style: TextStyle(
                            color: AppTheme.backgroundColor.withValues(
                              alpha: 0.6,
                            ),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 64),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Quick Links",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FooterLink("Features"),
                        _FooterLink("How It Works"),
                        _FooterLink("Events"),
                        _FooterLink("Blog"),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Connect",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FooterLink("Twitter"),
                        _FooterLink("LinkedIn"),
                        _FooterLink("Instagram"),
                        _FooterLink("Discord"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
              Divider(color: AppTheme.backgroundColor.withValues(alpha: 0.2)),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "© 2026 Teh Ais. Developed with ❤️ for Kitahack.",
                    style: TextStyle(
                      color: AppTheme.backgroundColor.withValues(alpha: 0.4),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: AppTheme.backgroundColor.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        "Terms of Service",
                        style: TextStyle(
                          color: AppTheme.backgroundColor.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.backgroundColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
