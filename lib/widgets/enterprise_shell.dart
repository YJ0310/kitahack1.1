import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../theme/app_theme.dart';

class EnterpriseShell extends StatelessWidget {
  final Widget child;
  const EnterpriseShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 860;
    return Scaffold(
      appBar: isDesktop ? null : _MobileAppBar(),
      drawer: isDesktop ? null : Drawer(child: _SidebarContent()),
      body: Row(
        children: [
          if (isDesktop) SizedBox(width: 240, child: _SidebarContent()),
          Expanded(
            child: Column(
              children: [
                if (isDesktop) _TopBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: Icon(
            Icons.menu_rounded,
            color: isDark ? Colors.white : AppTheme.textPrimaryColor,
          ),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Row(
        children: [
          Image.asset('assets/logo.png', width: 28, height: 28),
          const SizedBox(width: 8),
          Text(
            'Enterprise',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: isDark ? Colors.white : AppTheme.primaryDarkColor,
            ),
          ),
        ],
      ),
      actions: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, mode, __) => IconButton(
            icon: Icon(
              mode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: isDark ? Colors.white70 : AppTheme.primaryColor,
            ),
            onPressed: () => themeNotifier.value = mode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = GoRouterState.of(context).uri.toString();
    final crumbs = _buildCrumbs(location);
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : AppTheme.backgroundColor.withValues(alpha: 0.8),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: crumbs.asMap().entries.expand((entry) {
                final i = entry.key;
                final c = entry.value;
                final isLast = i == crumbs.length - 1;
                return [
                  GestureDetector(
                    onTap: isLast ? null : () => context.go(c['path']!),
                    child: Text(
                      c['label']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
                        color: isLast
                            ? (isDark
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor)
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.5,
                                    )),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : AppTheme.primaryColor.withValues(alpha: 0.35),
                      ),
                    ),
                ];
              }).toList(),
            ),
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, mode, __) {
              final d = mode == ThemeMode.dark;
              return GestureDetector(
                onTap: () =>
                    themeNotifier.value = d ? ThemeMode.light : ThemeMode.dark,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppTheme.backgroundColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        d ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        size: 14,
                        color: isDark ? Colors.amber : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        d ? 'Light' : 'Dark',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white70
                              : AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.purple,
            child: const Text(
              'T',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _buildCrumbs(String path) {
    final segs = path.split('/').where((s) => s.isNotEmpty).toList();
    final crumbs = <Map<String, String>>[
      {'label': 'Home', 'path': '/'},
    ];
    String cum = '';
    for (final s in segs) {
      cum += '/$s';
      crumbs.add({'label': _label(s), 'path': cum});
    }
    return crumbs;
  }

  String _label(String s) {
    switch (s) {
      case 'enterprise':
        return 'Enterprise Portal';
      case 'candidates':
        return 'Candidate Search';
      default:
        return s[0].toUpperCase() + s.substring(1);
    }
  }
}

class _SidebarContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = GoRouterState.of(context).uri.toString();
    return Container(
      color: isDark ? const Color(0xFF111111) : Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.deepPurple],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.business_center_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Enterprise',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.primaryDarkColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppTheme.backgroundColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.purple,
                    child: Text(
                      'T',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TechCorp Malaysia',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isDark
                                ? Colors.white
                                : AppTheme.textPrimaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Enterprise',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : AppTheme.primaryColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _NavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  path: '/enterprise',
                  currentPath: location,
                ),
                _NavItem(
                  icon: Icons.person_search_rounded,
                  label: 'Candidate Search',
                  path: '/enterprise/candidates',
                  currentPath: location,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (_, mode, __) {
                    final d = mode == ThemeMode.dark;
                    return GestureDetector(
                      onTap: () => themeNotifier.value = d
                          ? ThemeMode.light
                          : ThemeMode.dark,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : AppTheme.backgroundColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              d
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              size: 18,
                              color: isDark
                                  ? Colors.amber
                                  : AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                d ? 'Switch to Light' : 'Switch to Dark',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white70
                                      : AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => context.go('/'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.logout_rounded, size: 18, color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label, path, currentPath;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive =
        currentPath == path ||
        (path != '/enterprise' && currentPath.startsWith(path));
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () => context.go(path),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? Colors.white
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppTheme.primaryColor.withValues(alpha: 0.6)),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? Colors.white
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.6)
                            : AppTheme.primaryColor.withValues(alpha: 0.7)),
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
