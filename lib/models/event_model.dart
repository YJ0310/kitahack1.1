class EventModel {
  final String eventId;
  final String title;
  final String organizer;
  final String type;
  final bool isOfficial;
  final bool isAllMajors;
  final List<String> targetMajors;
  final String location;
  final String description;
  final DateTime? eventDate;
  final DateTime? createdAt;
  final List<int> relatedTags;
  final Map<String, dynamic> actionLinks;

  EventModel({
    required this.eventId,
    this.title = '',
    this.organizer = '',
    this.type = '',
    this.isOfficial = false,
    this.isAllMajors = true,
    this.targetMajors = const [],
    this.location = '',
    this.description = '',
    this.eventDate,
    this.createdAt,
    this.relatedTags = const [],
    this.actionLinks = const {},
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['event_id'] ?? '',
      title: json['title'] ?? '',
      organizer: json['organizer'] ?? '',
      type: json['type'] ?? '',
      isOfficial: json['is_official'] ?? false,
      isAllMajors: json['is_all_majors'] ?? true,
      targetMajors: List<String>.from(json['target_majors'] ?? []),
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      eventDate: _parseDate(json['event_date']),
      createdAt: _parseDate(json['created_at']),
      relatedTags: List<int>.from(json['related_tags'] ?? []),
      actionLinks: Map<String, dynamic>.from(json['action_links'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'organizer': organizer,
        'type': type,
        'is_official': isOfficial,
        'is_all_majors': isAllMajors,
        'target_majors': targetMajors,
        'location': location,
        'description': description,
        'related_tags': relatedTags,
        'action_links': actionLinks,
      };

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is String) return DateTime.tryParse(v);
    if (v is Map && v['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        (v['_seconds'] as int) * 1000,
      );
    }
    return null;
  }

  /// Helpers for the UI
  String get dateFormatted =>
      eventDate != null
          ? '${_monthNames[eventDate!.month - 1]} ${eventDate!.day}, ${eventDate!.year}'
          : '';

  String get month =>
      eventDate != null ? _shortMonths[eventDate!.month - 1] : '';
  String get day => eventDate != null ? '${eventDate!.day}' : '';

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const _shortMonths = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];
}
