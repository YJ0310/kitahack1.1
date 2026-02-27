import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class ResponsiveShell extends StatelessWidget {
  final Widget child;

  const ResponsiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 860;

    return Scaffold(
      appBar: isDesktop
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: _MobileAppBar(),
            ),
      drawer: isDesktop ? null : Drawer(child: _SidebarContent()),
      body: Row(
        children: [
          if (isDesktop) _DesktopSidebar(),
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

// ─────────────────────────────────────────────────────────
// Mobile App Bar
// ─────────────────────────────────────────────────────────
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
          Image.asset('assets/logo.png', width: 30, height: 30),
          const SizedBox(width: 8),
          Text(
            'Teh Ais',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
            onPressed: () {
              themeNotifier.value = mode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Desktop Top Bar (breadcrumb + dark mode + avatar)
// ─────────────────────────────────────────────────────────
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
          // Breadcrumb Trail
          Expanded(
            child: Row(
              children: crumbs.asMap().entries.expand((entry) {
                final i = entry.key;
                final crumb = entry.value;
                final isLast = i == crumbs.length - 1;
                return [
                  GestureDetector(
                    onTap: isLast ? null : () => context.go(crumb['path']!),
                    child: Text(
                      crumb['label']!,
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
          // Dark Mode Toggle
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, mode, __) {
              final isCurrentlyDark = mode == ThemeMode.dark;
              return GestureDetector(
                onTap: () {
                  themeNotifier.value = isCurrentlyDark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
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
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppTheme.backgroundColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCurrentlyDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        size: 14,
                        color: isDark ? Colors.amber : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isCurrentlyDark ? 'Light' : 'Dark',
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
          const SizedBox(width: 8),
          // Upload Button
          _UploadButton(isDark: isDark),
          const SizedBox(width: 12),
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              (AuthService().displayName ?? 'U')[0].toUpperCase(),
              style: const TextStyle(
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
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    final crumbs = <Map<String, String>>[
      {'label': 'Home', 'path': '/'},
    ];

    String cumulative = '';
    for (final seg in segments) {
      cumulative += '/$seg';
      crumbs.add({'label': _labelForSegment(seg), 'path': cumulative});
    }
    return crumbs;
  }

  String _labelForSegment(String seg) {
    switch (seg) {
      case 'student':
        return 'Student Portal';
      case 'event':
        return 'Events';
      case 'team':
        return 'Teams & Pairing';
      case 'profile':
        return 'Profile & Tags';
      case 'chat':
        return 'Chat';
      default:
        return seg[0].toUpperCase() + seg.substring(1);
    }
  }
}

// ─────────────────────────────────────────────────────────
// Desktop Sidebar
// ─────────────────────────────────────────────────────────
class _DesktopSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 240, child: _SidebarContent());
  }
}

// ─────────────────────────────────────────────────────────
// Shared Sidebar Content
// ─────────────────────────────────────────────────────────
class _SidebarContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      color: isDark ? const Color(0xFF111111) : Colors.white,
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryDarkColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Teh Ais',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.primaryDarkColor,
                  ),
                ),
              ],
            ),
          ),
          // User Chip
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
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      (AuthService().displayName ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
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
                          AuthService().displayName ?? 'User',
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
                          AuthService().role ?? 'Student',
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
          // Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _NavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  path: '/student',
                  currentPath: location,
                ),
                _NavItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Events',
                  path: '/student/event',
                  currentPath: location,
                ),
                _NavItem(
                  icon: Icons.groups_rounded,
                  label: 'Teams & Pairing',
                  path: '/student/team',
                  currentPath: location,
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile & Tags',
                  path: '/student/profile',
                  currentPath: location,
                ),
                _NavItem(
                  icon: Icons.chat_bubble_rounded,
                  label: 'Chat',
                  path: '/student/chat',
                  currentPath: location,
                ),
              ],
            ),
          ),
          // Bottom: Dark mode toggle + logout
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Dark Mode Toggle
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (_, mode, __) {
                    final isCurrentlyDark = mode == ThemeMode.dark;
                    return GestureDetector(
                      onTap: () {
                        themeNotifier.value = isCurrentlyDark
                            ? ThemeMode.light
                            : ThemeMode.dark;
                      },
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
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppTheme.backgroundColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isCurrentlyDark
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
                                isCurrentlyDark
                                    ? 'Switch to Light'
                                    : 'Switch to Dark',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white70
                                      : AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              width: 36,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isCurrentlyDark
                                    ? AppTheme.primaryColor
                                    : Colors.grey.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: AnimatedAlign(
                                duration: const Duration(milliseconds: 200),
                                alignment: isCurrentlyDark
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
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
                // Logout
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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout_rounded,
                          size: 18,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        const Text(
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

// ─────────────────────────────────────────────────────────
// Nav Item
// ─────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String path;
  final String currentPath;

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
        (path != '/student' && currentPath.startsWith(path));

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
                    colors: [AppTheme.primaryColor, AppTheme.primaryDarkColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive
                ? null
                : (isDark ? Colors.transparent : Colors.transparent),
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

// ─── Upload Button ──────────────────────────────────────
class _UploadButton extends StatefulWidget {
  final bool isDark;
  const _UploadButton({required this.isDark});

  @override
  State<_UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<_UploadButton> {
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg', 'webp'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;

    setState(() => _uploading = true);
    try {
      final mimeType = _guessMime(file.extension ?? '');
      await ApiService().uploadFile(
        file.bytes!,
        file.name,
        mimeType,
        folder: 'user-uploads',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uploaded ${file.name}'),
            backgroundColor: AppTheme.primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  String _guessMime(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':   return 'application/pdf';
      case 'doc':   return 'application/msword';
      case 'docx':  return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'png':   return 'image/png';
      case 'jpg':
      case 'jpeg':  return 'image/jpeg';
      case 'webp':  return 'image/webp';
      default:      return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Upload file',
      child: GestureDetector(
        onTap: _uploading ? null : _pickAndUpload,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppTheme.backgroundColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppTheme.backgroundColor,
            ),
          ),
          child: _uploading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  Icons.cloud_upload_rounded,
                  size: 16,
                  color: widget.isDark ? Colors.white70 : AppTheme.primaryColor,
                ),
        ),
      ),
    );
  }
}