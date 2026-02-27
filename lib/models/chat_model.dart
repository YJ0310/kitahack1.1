class ChatModel {
  final String chatId;
  final List<String> members;
  final String sourceType;
  final String sourceId;
  final String matchId;
  final String chatTitle;
  final String lastMessage;
  final DateTime? lastUpdatedAt;
  final bool isNotified;
  final String status;
  final DateTime? createdAt;
  final DateTime? expireAt;

  ChatModel({
    required this.chatId,
    this.members = const [],
    this.sourceType = 'Post',
    this.sourceId = '',
    this.matchId = '',
    this.chatTitle = '',
    this.lastMessage = '',
    this.lastUpdatedAt,
    this.isNotified = false,
    this.status = 'Active',
    this.createdAt,
    this.expireAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chat_id'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      sourceType: json['source_type'] ?? 'Post',
      sourceId: json['source_id'] ?? '',
      matchId: json['match_id'] ?? '',
      chatTitle: json['chat_title'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastUpdatedAt: _parseDate(json['last_updated_at']),
      isNotified: json['is_notified'] ?? false,
      status: json['status'] ?? 'Active',
      createdAt: _parseDate(json['created_at']),
      expireAt: _parseDate(json['expire_at']),
    );
  }

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
}

class MessageModel {
  final String messageId;
  final String senderId;
  final String text;
  final DateTime? timestamp;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    this.timestamp,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      text: json['text'] ?? '',
      timestamp: _parseDate(json['timestamp']),
      isRead: json['is_read'] ?? false,
    );
  }

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
}
