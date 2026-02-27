class MatchModel {
  final String matchId;
  final String postId;
  final String candidateId;
  final String matchType;
  final double? score;
  final String matchStatus;
  final String reason;
  final DateTime? createdAt;

  MatchModel({
    required this.matchId,
    required this.postId,
    required this.candidateId,
    this.matchType = '',
    this.score,
    this.matchStatus = 'Recommended',
    this.reason = '',
    this.createdAt,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['match_id'] ?? '',
      postId: json['post_id'] ?? '',
      candidateId: json['candidate_id'] ?? '',
      matchType: json['match_type'] ?? '',
      score: (json['score'] as num?)?.toDouble(),
      matchStatus: json['match_status'] ?? 'Recommended',
      reason: json['reason'] ?? '',
      createdAt: _parseDate(json['created_at']),
    );
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is String) return DateTime.tryParse(v);
    if (v is Map && v['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(v['_seconds'] * 1000);
    }
    return null;
  }
}
