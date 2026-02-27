class PostModel {
  final String postId;
  final String creatorId;
  final String type;
  final String title;
  final String description;
  final String status;
  final DateTime? createdAt;
  final List<dynamic> requirements;

  PostModel({
    required this.postId,
    required this.creatorId,
    this.type = '',
    this.title = '',
    this.description = '',
    this.status = 'Open',
    this.createdAt,
    this.requirements = const [],
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['post_id'] ?? '',
      creatorId: json['creator_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Open',
      createdAt: _parseDate(json['created_at']),
      requirements: List<dynamic>.from(json['requirements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'post_id': postId,
        'creator_id': creatorId,
        'type': type,
        'title': title,
        'description': description,
        'status': status,
        'requirements': requirements,
      };

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is String) return DateTime.tryParse(v);
    if (v is Map && v['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(v['_seconds'] * 1000);
    }
    return null;
  }
}
