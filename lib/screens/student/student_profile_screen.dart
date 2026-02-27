import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

// ─── Skill Level ──────────────────────────────────────────────────────────────
enum SkillLevel { interested, learning, competent, proficient, expert }

extension SkillLevelExt on SkillLevel {
  String get label => name[0].toUpperCase() + name.substring(1);

  Color get color {
    switch (this) {
      case SkillLevel.interested:
        return Colors.grey;
      case SkillLevel.learning:
        return Colors.blueAccent;
      case SkillLevel.competent:
        return Colors.green;
      case SkillLevel.proficient:
        return Colors.purple;
      case SkillLevel.expert:
        return Colors.amber;
    }
  }
}

// ─── Skill Model ─────────────────────────────────────────────────────────────
class _Skill {
  String name;
  SkillLevel level;
  _Skill(this.name, this.level);
}

// ─── Portfolio Item ───────────────────────────────────────────────────────────
class _PortfolioItem {
  final int id;
  final String title;
  final String description;
  final List<String> tags;

  _PortfolioItem({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // Profile state (loaded from API)
  String _name = '';
  String _faculty = '';
  String _location = '';
  String _email = '';
  String _bio = '';
  String _github = '';
  String _linkedin = '';
  String _joinDate = '';

  // Skills
  final List<_Skill> _skills = [];

  // Portfolio
  final List<_PortfolioItem> _portfolio = [];

  // Dialog states
  bool _showEditProfile = false;
  bool _showEditSkills = false;
  bool _showAddProject = false;

  // Temp edit controllers
  final _nameCtrl = TextEditingController();
  final _facultyCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  final _newSkillCtrl = TextEditingController();
  final _projTitleCtrl = TextEditingController();
  final _projDescCtrl = TextEditingController();
  final _projTagsCtrl = TextEditingController();
  SkillLevel _newSkillLevel = SkillLevel.interested;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _facultyCtrl.dispose();
    _locationCtrl.dispose();
    _bioCtrl.dispose();
    _githubCtrl.dispose();
    _linkedinCtrl.dispose();
    _newSkillCtrl.dispose();
    _projTitleCtrl.dispose();
    _projDescCtrl.dispose();
    _projTagsCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await ApiService().getProfile();
      if (profile != null && mounted) {
        setState(() {
          if (profile.name.isNotEmpty) _name = profile.name;
          if (profile.email.isNotEmpty) _email = profile.email;
          if (profile.portfolioUrl.isNotEmpty) _github = profile.portfolioUrl;
          if (profile.matricNo.isNotEmpty) _faculty = profile.matricNo;
          // Populate skills from tags
          if (profile.skillTags.isNotEmpty) {
            _skills.clear();
            for (final tag in profile.skillTags) {
              _skills.add(_Skill(
                tag['name']?.toString() ?? 'Tag ${tag['tag_id']}',
                SkillLevel.competent,
              ));
            }
          }
        });
      }
    } catch (_) {}
  }

  void _openEditProfile() {
    _nameCtrl.text = _name;
    _facultyCtrl.text = _faculty;
    _locationCtrl.text = _location;
    _bioCtrl.text = _bio;
    _githubCtrl.text = _github;
    _linkedinCtrl.text = _linkedin;
    setState(() => _showEditProfile = true);
  }

  void _saveProfile() {
    setState(() {
      _name = _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : _name;
      _faculty = _facultyCtrl.text.trim().isNotEmpty
          ? _facultyCtrl.text.trim()
          : _faculty;
      _location = _locationCtrl.text.trim().isNotEmpty
          ? _locationCtrl.text.trim()
          : _location;
      _bio = _bioCtrl.text.trim().isNotEmpty ? _bioCtrl.text.trim() : _bio;
      _github = _githubCtrl.text.trim().isNotEmpty
          ? _githubCtrl.text.trim()
          : _github;
      _linkedin = _linkedinCtrl.text.trim().isNotEmpty
          ? _linkedinCtrl.text.trim()
          : _linkedin;
      _showEditProfile = false;
    });
    // Push to backend
    ApiService().patchProfile({
      'name': _name,
      'email': _email,
      'portfolio_url': _github,
    }).catchError((_) {
      // ignore backend errors silently
    });
  }

  void _addSkill() {
    final name = _newSkillCtrl.text.trim();
    if (name.isNotEmpty && !_skills.any((s) => s.name == name)) {
      setState(() {
        _skills.add(_Skill(name, _newSkillLevel));
        _newSkillCtrl.clear();
      });
    }
  }

  void _removeSkill(String name) {
    setState(() => _skills.removeWhere((s) => s.name == name));
  }

  void _addProject() {
    final title = _projTitleCtrl.text.trim();
    final desc = _projDescCtrl.text.trim();
    final tags = _projTagsCtrl.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (title.isNotEmpty) {
      setState(() {
        _portfolio.add(
          _PortfolioItem(
            id: _portfolio.length + 1,
            title: title,
            description: desc,
            tags: tags,
          ),
        );
        _projTitleCtrl.clear();
        _projDescCtrl.clear();
        _projTagsCtrl.clear();
        _showAddProject = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Card
                _ProfileHeader(
                  isDark: isDark,
                  name: _name,
                  faculty: _faculty,
                  location: _location,
                  email: _email,
                  bio: _bio,
                  github: _github,
                  linkedin: _linkedin,
                  joinDate: _joinDate,
                  onEdit: _openEditProfile,
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 20),
                // Skills Section
                _SkillsSection(
                  isDark: isDark,
                  skills: _skills,
                  onEdit: () => setState(() => _showEditSkills = true),
                ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
                const SizedBox(height: 20),
                // Portfolio Section
                _PortfolioSection(
                  isDark: isDark,
                  items: _portfolio,
                  width: width,
                  onAddProject: () => setState(() => _showAddProject = true),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                const SizedBox(height: 32),
              ],
            ),
          ),
          // Edit Profile Dialog
          if (_showEditProfile)
            _ModalDialog(
              isDark: isDark,
              title: 'Edit Profile',
              icon: Icons.edit_rounded,
              onClose: () => setState(() => _showEditProfile = false),
              child: _EditProfileBody(
                isDark: isDark,
                nameCtrl: _nameCtrl,
                facultyCtrl: _facultyCtrl,
                locationCtrl: _locationCtrl,
                bioCtrl: _bioCtrl,
                githubCtrl: _githubCtrl,
                linkedinCtrl: _linkedinCtrl,
                onSave: _saveProfile,
                onCancel: () => setState(() => _showEditProfile = false),
              ),
            ),
          // Edit Skills Dialog
          if (_showEditSkills)
            _ModalDialog(
              isDark: isDark,
              title: 'Edit Skills & Interests',
              icon: Icons.star_rounded,
              onClose: () => setState(() => _showEditSkills = false),
              child: _EditSkillsBody(
                isDark: isDark,
                skills: _skills,
                newSkillCtrl: _newSkillCtrl,
                selectedLevel: _newSkillLevel,
                onLevelChanged: (l) => setState(() => _newSkillLevel = l),
                onAdd: _addSkill,
                onRemove: _removeSkill,
                onUpdateLevel: (name, level) {
                  setState(() {
                    final idx = _skills.indexWhere((s) => s.name == name);
                    if (idx != -1) _skills[idx].level = level;
                  });
                },
                onSave: () => setState(() => _showEditSkills = false),
              ),
            ),
          // Add Project Dialog
          if (_showAddProject)
            _ModalDialog(
              isDark: isDark,
              title: 'Add Project',
              icon: Icons.add_rounded,
              onClose: () => setState(() => _showAddProject = false),
              child: _AddProjectBody(
                isDark: isDark,
                titleCtrl: _projTitleCtrl,
                descCtrl: _projDescCtrl,
                tagsCtrl: _projTagsCtrl,
                onSave: _addProject,
                onCancel: () => setState(() => _showAddProject = false),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Profile Header ───────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final bool isDark;
  final String name, faculty, location, email, bio, github, linkedin, joinDate;
  final VoidCallback onEdit;

  const _ProfileHeader({
    required this.isDark,
    required this.name,
    required this.faculty,
    required this.location,
    required this.email,
    required this.bio,
    required this.github,
    required this.linkedin,
    required this.joinDate,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.backgroundColor.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cover
          Stack(
            children: [
              Container(
                height: 130,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
              ),
              // Edit Profile button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.secondaryColor,
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1A1A1A)
                                : Colors.white,
                            width: 4,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Name + Faculty (negative gap from avatar)
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                      Text(
                        faculty,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : AppTheme.primaryColor.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        bio,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.55,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppTheme.primaryColor.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Meta badges
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _MetaTag(Icons.location_on_rounded, location, isDark),
                          _MetaTag(Icons.email_rounded, email, isDark),
                          _MetaTag(
                            Icons.calendar_today_rounded,
                            'Joined $joinDate',
                            isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Social icons
                      Row(
                        children: [
                          if (github.isNotEmpty)
                            _SocialBtn(Icons.code_rounded, github, isDark),
                          if (linkedin.isNotEmpty)
                            _SocialBtn(
                              Icons.business_rounded,
                              linkedin,
                              isDark,
                            ),
                        ],
                      ),
                    ],
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

class _MetaTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const _MetaTag(this.icon, this.text, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: isDark
              ? Colors.white.withValues(alpha: 0.4)
              : AppTheme.primaryColor.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? Colors.white.withValues(alpha: 0.5)
                : AppTheme.primaryColor.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String handle;
  final bool isDark;

  const _SocialBtn(this.icon, this.handle, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppTheme.backgroundColor.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppTheme.primaryColor),
            const SizedBox(width: 6),
            Text(
              handle,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Skills Section ───────────────────────────────────────────────────────────
class _SkillsSection extends StatelessWidget {
  final bool isDark;
  final List<_Skill> skills;
  final VoidCallback onEdit;

  const _SkillsSection({
    required this.isDark,
    required this.skills,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.backgroundColor.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Skills & Interests',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        size: 13,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Level legend
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: SkillLevel.values
                .map(
                  (l) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: l.color.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : AppTheme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((s) => _SkillBadge(s, isDark)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillBadge extends StatelessWidget {
  final _Skill skill;
  final bool isDark;
  const _SkillBadge(this.skill, this.isDark);

  @override
  Widget build(BuildContext context) {
    final color = skill.level.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            skill.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Portfolio Section ────────────────────────────────────────────────────────
class _PortfolioSection extends StatelessWidget {
  final bool isDark;
  final List<_PortfolioItem> items;
  final double width;
  final VoidCallback onAddProject;

  const _PortfolioSection({
    required this.isDark,
    required this.items,
    required this.width,
    required this.onAddProject,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = width > 900;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.backgroundColor.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work_rounded,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Portfolio',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onAddProject,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 13,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Add Project',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 2 : 1,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: isWide ? 2.0 : 2.5,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) =>
                _PortfolioCard(item: items[i], isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final _PortfolioItem item;
  final bool isDark;

  const _PortfolioCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : AppTheme.backgroundColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.backgroundColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color icon block
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  item.title[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                item.description,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : AppTheme.primaryColor.withValues(alpha: 0.6),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: item.tags
                  .map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Generic Modal Dialog ─────────────────────────────────────────────────────
class _ModalDialog extends StatelessWidget {
  final bool isDark;
  final String title;
  final IconData icon;
  final VoidCallback onClose;
  final Widget child;

  const _ModalDialog({
    required this.isDark,
    required this.title,
    required this.icon,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560, maxHeight: 600),
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 32,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryDarkColor,
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                            ),
                            onPressed: onClose,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                    Flexible(child: SingleChildScrollView(child: child)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Edit Profile Body ────────────────────────────────────────────────────────
class _EditProfileBody extends StatelessWidget {
  final bool isDark;
  final TextEditingController nameCtrl,
      facultyCtrl,
      locationCtrl,
      bioCtrl,
      githubCtrl,
      linkedinCtrl;
  final VoidCallback onSave, onCancel;

  const _EditProfileBody({
    required this.isDark,
    required this.nameCtrl,
    required this.facultyCtrl,
    required this.locationCtrl,
    required this.bioCtrl,
    required this.githubCtrl,
    required this.linkedinCtrl,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormField(label: 'Full Name', ctrl: nameCtrl, isDark: isDark),
          _FormField(label: 'Faculty', ctrl: facultyCtrl, isDark: isDark),
          _FormField(label: 'Location', ctrl: locationCtrl, isDark: isDark),
          _FormField(label: 'Bio', ctrl: bioCtrl, isDark: isDark, maxLines: 3),
          _FormField(label: 'GitHub', ctrl: githubCtrl, isDark: isDark),
          _FormField(label: 'LinkedIn', ctrl: linkedinCtrl, isDark: isDark),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppTheme.primaryColor.withValues(alpha: 0.3),
                    ),
                    foregroundColor: isDark
                        ? Colors.white70
                        : AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save_rounded, size: 16),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─── Edit Skills Body ─────────────────────────────────────────────────────────
class _EditSkillsBody extends StatelessWidget {
  final bool isDark;
  final List<_Skill> skills;
  final TextEditingController newSkillCtrl;
  final SkillLevel selectedLevel;
  final ValueChanged<SkillLevel> onLevelChanged;
  final VoidCallback onAdd;
  final void Function(String) onRemove;
  final void Function(String, SkillLevel) onUpdateLevel;
  final VoidCallback onSave;

  const _EditSkillsBody({
    required this.isDark,
    required this.skills,
    required this.newSkillCtrl,
    required this.selectedLevel,
    required this.onLevelChanged,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdateLevel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Skill Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: newSkillCtrl,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Skill name...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.3)
                          : AppTheme.primaryColor.withValues(alpha: 0.4),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : AppTheme.backgroundColor.withValues(alpha: 0.4),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<SkillLevel>(
                value: selectedLevel,
                onChanged: (l) {
                  if (l != null) onLevelChanged(l);
                },
                dropdownColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                style: TextStyle(fontSize: 12, color: selectedLevel.color),
                underline: const SizedBox(),
                items: SkillLevel.values
                    .map(
                      (l) => DropdownMenuItem(
                        value: l,
                        child: Text(
                          l.label,
                          style: TextStyle(color: l.color, fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                child: const Text('Add', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Skills List
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: skills.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (_, i) {
                final skill = skills[i];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppTheme.backgroundColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: skill.level.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          skill.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isDark
                                ? Colors.white
                                : AppTheme.textPrimaryColor,
                          ),
                        ),
                      ),
                      DropdownButton<SkillLevel>(
                        value: skill.level,
                        onChanged: (l) {
                          if (l != null) onUpdateLevel(skill.name, l);
                        },
                        dropdownColor: isDark
                            ? const Color(0xFF1A1A1A)
                            : Colors.white,
                        style: TextStyle(
                          fontSize: 11,
                          color: skill.level.color,
                        ),
                        underline: const SizedBox(),
                        items: SkillLevel.values
                            .map(
                              (l) => DropdownMenuItem(
                                value: l,
                                child: Text(
                                  l.label,
                                  style: TextStyle(
                                    color: l.color,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => onRemove(skill.name),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save_rounded, size: 16),
              label: const Text('Save Skills'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─── Add Project Body ─────────────────────────────────────────────────────────
class _AddProjectBody extends StatelessWidget {
  final bool isDark;
  final TextEditingController titleCtrl, descCtrl, tagsCtrl;
  final VoidCallback onSave, onCancel;

  const _AddProjectBody({
    required this.isDark,
    required this.titleCtrl,
    required this.descCtrl,
    required this.tagsCtrl,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormField(label: 'Project Title', ctrl: titleCtrl, isDark: isDark),
          _FormField(
            label: 'Description',
            ctrl: descCtrl,
            isDark: isDark,
            maxLines: 3,
          ),
          _FormField(
            label: 'Tags (comma-separated)',
            ctrl: tagsCtrl,
            isDark: isDark,
            hint: 'e.g. Flutter, Firebase, React',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppTheme.primaryColor.withValues(alpha: 0.3),
                    ),
                    foregroundColor: isDark
                        ? Colors.white70
                        : AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─── Shared Form Field ────────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController ctrl;
  final bool isDark;
  final int maxLines;

  const _FormField({
    required this.label,
    required this.ctrl,
    required this.isDark,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.6)
                  : AppTheme.primaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.3)
                    : AppTheme.primaryColor.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : AppTheme.backgroundColor.withValues(alpha: 0.4),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
