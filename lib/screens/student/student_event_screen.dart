import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

// ─────────────────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────────────────
class EventModel {
  final int id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String category;
  final bool teamRequired;
  final int? teamMin;
  final int? teamMax;
  final int spots;
  final int totalSpots;
  final String organizer;
  final List<String> tags;
  bool isRecommended;
  bool isRegistered;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.teamRequired,
    this.teamMin,
    this.teamMax,
    required this.spots,
    required this.totalSpots,
    required this.organizer,
    required this.tags,
    this.isRecommended = false,
    this.isRegistered = false,
  });
}

const _categories = [
  {'value': 'all', 'label': 'All Events'},
  {'value': 'hackathon', 'label': 'Hackathons'},
  {'value': 'workshop', 'label': 'Workshops'},
  {'value': 'networking', 'label': 'Networking'},
  {'value': 'competition', 'label': 'Competitions'},
];

// ─────────────────────────────────────────────────────────
// Main Screen
// ─────────────────────────────────────────────────────────
class StudentEventScreen extends StatefulWidget {
  const StudentEventScreen({super.key});

  @override
  State<StudentEventScreen> createState() => _StudentEventScreenState();
}

class _StudentEventScreenState extends State<StudentEventScreen> {
  List<EventModel> _events = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';
  EventModel? _selectedEvent;
  bool _showRoomDialog = false;
  bool _loadingEvents = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final apiEvents = await ApiService().getEvents();
      final converted = apiEvents.map((e) => EventModel(
            id: e.eventId.hashCode,
            title: e.title,
            description: e.description,
            date: e.dateFormatted,
            time: e.eventDate != null
                ? '${e.eventDate!.hour}:${e.eventDate!.minute.toString().padLeft(2, '0')}'
                : '',
            location: e.location,
            category: e.type.toLowerCase(),
            teamRequired: e.type == 'Competition',
            spots: 50,
            totalSpots: 100,
            organizer: e.organizer,
            tags: e.relatedTags.map((t) => t.toString()).toList(),
            isRecommended: false,
          )).toList();

      // Fetch AI recommendations and mark matching events
      try {
        final recs = await ApiService().recommendEvents();
        final recTitles = recs
            .map((r) => (Map<String, dynamic>.from(r)['title'] ?? '').toString().toLowerCase())
            .where((t) => t.isNotEmpty)
            .toSet();
        for (final event in converted) {
          if (recTitles.contains(event.title.toLowerCase())) {
            event.isRecommended = true;
          }
        }
        // Also add recommended events not already in list
        for (final r in recs) {
          final m = Map<String, dynamic>.from(r);
          final title = (m['title'] ?? '').toString();
          if (title.isNotEmpty && !converted.any((e) => e.title.toLowerCase() == title.toLowerCase())) {
            converted.add(EventModel(
              id: title.hashCode,
              title: title,
              description: m['reason'] ?? m['description'] ?? 'AI recommended',
              date: m['date'] ?? '',
              time: '',
              location: m['location'] ?? '',
              category: (m['type'] ?? m['category'] ?? 'event').toString().toLowerCase(),
              teamRequired: false,
              spots: 50,
              totalSpots: 100,
              organizer: m['organizer'] ?? '',
              tags: List<String>.from(m['tags'] ?? []),
              isRecommended: true,
            ));
          }
        }
      } catch (_) {}

      if (mounted) {
        setState(() {
          _events = converted;
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingEvents = false);
  }

  List<EventModel> get _filtered {
    return _events.where((e) {
      final matchSearch =
          e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCat =
          _selectedCategory == 'all' || e.category == _selectedCategory;
      return matchSearch && matchCat;
    }).toList();
  }

  void _handleAction(EventModel event) {
    setState(() => _selectedEvent = event);
    if (event.teamRequired) {
      setState(() => _showRoomDialog = true);
    } else {
      // Direct register
      _showSuccessSnackBar(event);
    }
  }

  void _showSuccessSnackBar(EventModel event) {
    setState(() => event.isRegistered = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text('Registered for ${event.title}!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recommended = _filtered.where((e) => e.isRecommended).toList();
    final others = _filtered.where((e) => !e.isRecommended).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Discover Events',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                Text(
                  'Find events that match your interests and skills',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : AppTheme.primaryColor.withValues(alpha: 0.6),
                  ),
                ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
                const SizedBox(height: 20),
                // Search + Filter Bar
                _SearchFilterBar(
                  isDark: isDark,
                  searchQuery: _searchQuery,
                  selectedCategory: _selectedCategory,
                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                  onCategoryChanged: (v) =>
                      setState(() => _selectedCategory = v),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                const SizedBox(height: 24),
                // Recommended Section
                if (recommended.isNotEmpty) ...[
                  _SectionLabel(
                    icon: Icons.star_rounded,
                    label: 'Recommended For You',
                    iconColor: Colors.amber,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _EventGrid(
                    events: recommended,
                    isDark: isDark,
                    onView: (e) => setState(() => _selectedEvent = e),
                    onAction: _handleAction,
                  ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
                  const SizedBox(height: 28),
                ],
                // All Events
                _SectionLabel(
                  icon: Icons.explore_rounded,
                  label: recommended.isNotEmpty
                      ? 'Explore All Events'
                      : 'All Events',
                  iconColor: AppTheme.secondaryColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                if (others.isEmpty && recommended.isEmpty)
                  _EmptyState(isDark: isDark)
                else
                  _EventGrid(
                    events: others.isEmpty ? recommended : others,
                    isDark: isDark,
                    onView: (e) => setState(() => _selectedEvent = e),
                    onAction: _handleAction,
                    showAll: recommended.isEmpty,
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                const SizedBox(height: 32),
              ],
            ),
          ),
          // Event Detail Modal
          if (_selectedEvent != null && !_showRoomDialog)
            _EventDetailSheet(
              event: _selectedEvent!,
              isDark: isDark,
              onClose: () => setState(() => _selectedEvent = null),
              onAction: () {
                if (_selectedEvent!.teamRequired) {
                  setState(() => _showRoomDialog = true);
                } else {
                  _showSuccessSnackBar(_selectedEvent!);
                  setState(() => _selectedEvent = null);
                }
              },
            ),
          // Room Dialog
          if (_showRoomDialog && _selectedEvent != null)
            _RoomDialog(
              event: _selectedEvent!,
              isDark: isDark,
              onClose: () {
                setState(() {
                  _showRoomDialog = false;
                  _selectedEvent = null;
                });
              },
              onJoinedRoom: () {
                setState(() {
                  _showRoomDialog = false;
                  _selectedEvent = null;
                });
                context.go('/student/team');
              },
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Search + Filter Bar
// ─────────────────────────────────────────────────────────
class _SearchFilterBar extends StatelessWidget {
  final bool isDark;
  final String searchQuery;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;

  const _SearchFilterBar({
    required this.isDark,
    required this.searchQuery,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.backgroundColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          TextField(
            onChanged: onSearchChanged,
            style: TextStyle(
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Search events...',
              hintStyle: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.3)
                    : AppTheme.primaryColor.withValues(alpha: 0.4),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.4)
                    : AppTheme.primaryColor.withValues(alpha: 0.5),
                size: 20,
              ),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : AppTheme.backgroundColor.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = selectedCategory == cat['value'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onCategoryChanged(cat['value']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [
                                  AppTheme.primaryColor,
                                  AppTheme.primaryDarkColor,
                                ],
                              )
                            : null,
                        color: isSelected
                            ? null
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : AppTheme.backgroundColor.withValues(
                                      alpha: 0.5,
                                    )),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat['label']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : AppTheme.primaryColor.withValues(
                                        alpha: 0.7,
                                      )),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Section Label
// ─────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final bool isDark;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Event Grid
// ─────────────────────────────────────────────────────────
class _EventGrid extends StatelessWidget {
  final List<EventModel> events;
  final bool isDark;
  final void Function(EventModel) onView;
  final void Function(EventModel) onAction;
  final bool showAll;

  const _EventGrid({
    required this.events,
    required this.isDark,
    required this.onView,
    required this.onAction,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 2 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isWide ? 2.0 : 2.2,
      ),
      itemCount: events.length,
      itemBuilder: (context, i) => _EventCard(
        event: events[i],
        isDark: isDark,
        onView: () => onView(events[i]),
        onAction: () => onAction(events[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Event Card
// ─────────────────────────────────────────────────────────
class _EventCard extends StatelessWidget {
  final EventModel event;
  final bool isDark;
  final VoidCallback onView;
  final VoidCallback onAction;

  const _EventCard({
    required this.event,
    required this.isDark,
    required this.onView,
    required this.onAction,
  });

  Color get _categoryColor {
    switch (event.category) {
      case 'hackathon':
        return const Color(0xFF8C5535);
      case 'workshop':
        return const Color(0xFF5552CC);
      case 'networking':
        return const Color(0xFF22A66E);
      case 'competition':
        return const Color(0xFFE05D2B);
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spotsPercent = (event.spots / event.totalSpots).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onView,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppTheme.backgroundColor.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: category + badges
              Row(
                children: [
                  _MiniTag(label: event.category, color: _categoryColor),
                  if (event.teamRequired) ...[
                    const SizedBox(width: 6),
                    _MiniTag(label: 'Team', color: AppTheme.primaryColor),
                  ],
                  if (event.isRegistered) ...[
                    const SizedBox(width: 6),
                    _MiniTag(label: 'Registered ✓', color: Colors.green),
                  ],
                  const Spacer(),
                  if (event.isRecommended)
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Colors.amber,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Title
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : AppTheme.primaryColor.withValues(alpha: 0.6),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              // Date + Location
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : AppTheme.primaryColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    event.date,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppTheme.primaryColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.location_on_rounded,
                    size: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : AppTheme.primaryColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Spots Progress
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Spots left',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : AppTheme.primaryColor.withValues(
                                        alpha: 0.5,
                                      ),
                              ),
                            ),
                            Text(
                              '${event.spots}/${event.totalSpots}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: spotsPercent,
                            minHeight: 5,
                            backgroundColor: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppTheme.backgroundColor.withValues(
                                    alpha: 0.5,
                                  ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onView,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : AppTheme.primaryColor.withValues(alpha: 0.4),
                        ),
                        foregroundColor: isDark
                            ? Colors.white70
                            : AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Details'),
                    ),
                  ),
                  if (!event.isRegistered) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(
                          event.teamRequired ? 'Find Team' : 'Register',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppTheme.backgroundColor,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 48,
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : AppTheme.primaryColor.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'No events found',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.4)
                  : AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Event Detail Sheet (Full-screen overlay)
// ─────────────────────────────────────────────────────────
class _EventDetailSheet extends StatelessWidget {
  final EventModel event;
  final bool isDark;
  final VoidCallback onClose;
  final VoidCallback onAction;

  const _EventDetailSheet({
    required this.event,
    required this.isDark,
    required this.onClose,
    required this.onAction,
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
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
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
                    // Header bar
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
                          Expanded(
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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
                    // Body
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _detailRow(
                              Icons.person_rounded,
                              'Organizer: ${event.organizer}',
                              isDark,
                            ),
                            _detailRow(
                              Icons.calendar_today_rounded,
                              '${event.date} • ${event.time}',
                              isDark,
                            ),
                            _detailRow(
                              Icons.location_on_rounded,
                              event.location,
                              isDark,
                            ),
                            _detailRow(
                              Icons.people_rounded,
                              '${event.spots} / ${event.totalSpots} spots left',
                              isDark,
                            ),
                            if (event.teamRequired && event.teamMin != null)
                              _detailRow(
                                Icons.groups_rounded,
                                'Team size: ${event.teamMin}–${event.teamMax} members',
                                isDark,
                              ),
                            const SizedBox(height: 12),
                            Text(
                              event.description,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppTheme.primaryColor.withValues(
                                        alpha: 0.8,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: event.tags
                                  .map(
                                    (t) => _MiniTag(
                                      label: t,
                                      color: AppTheme.primaryColor,
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            if (!event.isRegistered)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: onAction,
                                  icon: Icon(
                                    event.teamRequired
                                        ? Icons.groups_rounded
                                        : Icons.check_circle_rounded,
                                  ),
                                  label: Text(
                                    event.teamRequired
                                        ? 'Create/Join Team Room'
                                        : 'Register Now',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'You\'re registered!',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark
                ? Colors.white.withValues(alpha: 0.4)
                : AppTheme.primaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : AppTheme.primaryColor.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Room Dialog (Create / Join)
// ─────────────────────────────────────────────────────────
class _RoomDialog extends StatefulWidget {
  final EventModel event;
  final bool isDark;
  final VoidCallback onClose;
  final VoidCallback onJoinedRoom;

  const _RoomDialog({
    required this.event,
    required this.isDark,
    required this.onClose,
    required this.onJoinedRoom,
  });

  @override
  State<_RoomDialog> createState() => _RoomDialogState();
}

class _RoomDialogState extends State<_RoomDialog> {
  int? _joiningRoomIndex;
  bool _creatingNew = false;
  List<Map<String, dynamic>> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final posts = await ApiService().getPosts();
      if (mounted) {
        setState(() {
          _rooms = posts.take(5).map((p) => <String, dynamic>{
            'name': p.title.isNotEmpty ? p.title : 'Room',
            'members': 1,
            'max': 4,
            'skills': p.requirements.map((r) => 'Tag $r').toList(),
          }).toList();
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
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
                          const Icon(
                            Icons.groups_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Team Room',
                              style: TextStyle(
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
                            onPressed: widget.onClose,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event info banner
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : AppTheme.backgroundColor.withValues(
                                      alpha: 0.3,
                                    ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.event_rounded,
                                  size: 14,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.event.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                                if (widget.event.teamMin != null)
                                  Text(
                                    'Team: ${widget.event.teamMin}–${widget.event.teamMax}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: widget.isDark
                                          ? Colors.white.withValues(alpha: 0.5)
                                          : AppTheme.primaryColor.withValues(
                                              alpha: 0.6,
                                            ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Create New Room button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() => _creatingNew = true);
                                Future.delayed(
                                  const Duration(milliseconds: 800),
                                  () {
                                    if (mounted) widget.onJoinedRoom();
                                  },
                                );
                              },
                              icon: _creatingNew
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.add_circle_rounded),
                              label: Text(
                                _creatingNew ? 'Creating…' : 'Create New Room',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              '— or browse open rooms —',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.isDark
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : AppTheme.primaryColor.withValues(
                                        alpha: 0.4,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Room List
                          ..._rooms.asMap().entries.map(
                            (entry) => _RoomTile(
                              room: entry.value,
                              index: entry.key,
                              isDark: widget.isDark,
                              isJoining: _joiningRoomIndex == entry.key,
                              onJoin: () {
                                setState(() => _joiningRoomIndex = entry.key);
                                Future.delayed(
                                  const Duration(milliseconds: 800),
                                  () {
                                    if (mounted) widget.onJoinedRoom();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _RoomTile extends StatelessWidget {
  final Map<String, dynamic> room;
  final int index;
  final bool isDark;
  final bool isJoining;
  final VoidCallback onJoin;

  const _RoomTile({
    required this.room,
    required this.index,
    required this.isDark,
    required this.isJoining,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final skills = room['skills'] as List;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : AppTheme.backgroundColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppTheme.backgroundColor,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${room['members']}/${room['max']} members',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : AppTheme.primaryColor.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    children: skills
                        .map(
                          (s) => _MiniTag(
                            label: s as String,
                            color: AppTheme.primaryColor,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: isJoining ? null : onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: isJoining
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
