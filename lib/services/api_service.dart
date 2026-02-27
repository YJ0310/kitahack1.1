import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// Central API service for communicating with the kitahack-tehais backend.
///
/// Uses a dev UID header for auth in development; can be swapped to
/// real Firebase ID tokens in production.
class ApiService {
  // Singleton
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;
  ApiService._();

  /// Backend URL — localhost in debug, relative path in production (same origin via App Hosting).
  static const String _baseUrl = kDebugMode
      ? 'http://localhost:3000/api'
      : '/api';

  /// Current user UID – set after login/role selection.
  String? _uid;
  String? _idToken;
  String? get uid => _uid;

  void setUid(String uid) => _uid = uid;
  void clearUid() {
    _uid = null;
    _idToken = null;
  }

  /// Set the Firebase ID token for Bearer auth.
  void setToken(String token) => _idToken = token;

  // ─── HTTP Helpers ──────────────────────────────────────────────────────────

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_idToken != null)
          'Authorization': 'Bearer $_idToken'
        else if (_uid != null)
          'X-Dev-UID': _uid!,
      };

  Future<dynamic> _get(String path) async {
    final res = await http.get(Uri.parse('$_baseUrl$path'), headers: _headers);
    return _handle(res);
  }

  Future<dynamic> _post(String path, [Map<String, dynamic>? body]) async {
    final res = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(res);
  }

  Future<dynamic> _put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  Future<dynamic> _patch(String path, Map<String, dynamic> body) async {
    final res = await http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  dynamic _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }
    final msg =
        res.body.isNotEmpty ? jsonDecode(res.body)['error'] ?? res.body : 'Unknown error';
    throw ApiException(res.statusCode, msg.toString());
  }

  // ─── Health ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> health() async {
    final data = await _get('/health');
    return Map<String, dynamic>.from(data);
  }

  // ─── Users ─────────────────────────────────────────────────────────────────

  Future<UserModel?> getProfile() async {
    try {
      final data = await _get('/users/profile');
      return UserModel.fromJson(data['user'] ?? data);
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<UserModel> upsertProfile(Map<String, dynamic> fields) async {
    final data = await _put('/users/profile', fields);
    return UserModel.fromJson(data['user'] ?? data);
  }

  Future<UserModel> patchProfile(Map<String, dynamic> fields) async {
    final data = await _patch('/users/profile', fields);
    return UserModel.fromJson(data['user'] ?? data);
  }

  Future<List<String>> autoTagUser(
      {required String skills, required String bio}) async {
    final data = await _post('/users/auto-tag', {
      'skills': skills,
      'bio': bio,
    });
    return List<String>.from(data['suggestedTags'] ?? []);
  }

  Future<UserModel> applyTags(List<int> tagIds) async {
    final data = await _post('/users/apply-tags', {'tagIds': tagIds});
    return UserModel.fromJson(data['user'] ?? data);
  }

  // ─── Tags ──────────────────────────────────────────────────────────────────

  Future<List<TagModel>> getTags({int? category}) async {
    final q = category != null ? '?category=$category' : '';
    final data = await _get('/tags$q');
    final list = data['tags'] ?? data;
    return (list as List).map((t) => TagModel.fromJson(t)).toList();
  }

  // ─── Posts ─────────────────────────────────────────────────────────────────

  Future<List<PostModel>> getPosts() async {
    final data = await _get('/posts');
    final list = data['posts'] ?? data;
    return (list as List).map((p) => PostModel.fromJson(p)).toList();
  }

  Future<List<PostModel>> getMyPosts() async {
    final data = await _get('/posts/mine');
    final list = data['posts'] ?? data;
    return (list as List).map((p) => PostModel.fromJson(p)).toList();
  }

  Future<PostModel> createPost(Map<String, dynamic> body) async {
    final data = await _post('/posts', body);
    return PostModel.fromJson(data['post'] ?? data);
  }

  Future<Map<String, dynamic>> autoTagPost(
      {required String title, required String description}) async {
    final data = await _post('/posts/auto-tag', {
      'title': title,
      'description': description,
    });
    return Map<String, dynamic>.from(data);
  }

  Future<PostModel> createPostFromDescription(String description) async {
    final data =
        await _post('/posts/create-from-description', {'description': description});
    return PostModel.fromJson(data['post'] ?? data);
  }

  // ─── Matches ───────────────────────────────────────────────────────────────

  Future<List<MatchModel>> getMyMatches() async {
    final data = await _get('/matches/mine');
    final list = data['matches'] ?? data;
    return (list as List).map((m) => MatchModel.fromJson(m)).toList();
  }

  Future<List<MatchModel>> getMatchesByPost(String postId) async {
    final data = await _get('/matches/post/$postId');
    final list = data['matches'] ?? data;
    return (list as List).map((m) => MatchModel.fromJson(m)).toList();
  }

  Future<Map<String, dynamic>> findCandidates(String postId) async {
    final data = await _post('/matches/find-candidates', {'postId': postId});
    return Map<String, dynamic>.from(data);
  }

  Future<MatchModel> applyToPost(
      {required String postId, String message = ''}) async {
    final data =
        await _post('/matches/apply', {'postId': postId, 'message': message});
    return MatchModel.fromJson(data['match'] ?? data);
  }

  Future<Map<String, dynamic>> acceptMatch(String matchId) async {
    final data = await _post('/matches/$matchId/accept');
    return Map<String, dynamic>.from(data);
  }

  Future<void> rejectMatch(String matchId) async {
    await _post('/matches/$matchId/reject');
  }

  Future<Map<String, dynamic>> autoPairTeams(String eventId) async {
    final data = await _post('/matches/auto-pair', {'eventId': eventId});
    return Map<String, dynamic>.from(data);
  }

  Future<List<dynamic>> smartSearch(String query) async {
    final data = await _post('/matches/smart-search', {'query': query});
    return data['results'] ?? [];
  }

  // ─── Events ────────────────────────────────────────────────────────────────

  Future<List<EventModel>> getEvents(
      {String? type, bool upcoming = false}) async {
    final params = <String>[];
    if (type != null) params.add('type=$type');
    if (upcoming) params.add('upcoming=true');
    final q = params.isNotEmpty ? '?${params.join('&')}' : '';
    final data = await _get('/events$q');
    final list = data['events'] ?? data;
    return (list as List).map((e) => EventModel.fromJson(e)).toList();
  }

  Future<EventModel> getEvent(String eventId) async {
    final data = await _get('/events/$eventId');
    return EventModel.fromJson(data['event'] ?? data);
  }

  Future<List<dynamic>> recommendEvents() async {
    final data = await _post('/events/recommend');
    return data['recommendations'] ?? [];
  }

  Future<List<dynamic>> searchEvents(String query) async {
    final data = await _post('/events/search', {'query': query});
    return data['results'] ?? data['events'] ?? [];
  }

  Future<Map<String, dynamic>> joinEvent(String eventId) async {
    final data = await _post('/events/$eventId/join');
    return Map<String, dynamic>.from(data);
  }

  Future<List<dynamic>> getEventParticipants(String eventId) async {
    final data = await _get('/events/$eventId/participants');
    return data['participants'] ?? data;
  }

  // ─── Chats ─────────────────────────────────────────────────────────────────

  Future<List<ChatModel>> getChats() async {
    final data = await _get('/chats');
    final list = data['chats'] ?? data;
    return (list as List).map((c) => ChatModel.fromJson(c)).toList();
  }

  Future<ChatModel> getChat(String chatId) async {
    final data = await _get('/chats/$chatId');
    return ChatModel.fromJson(data['chat'] ?? data);
  }

  Future<List<MessageModel>> getMessages(String chatId) async {
    final data = await _get('/chats/$chatId/messages');
    final list = data['messages'] ?? data;
    return (list as List).map((m) => MessageModel.fromJson(m)).toList();
  }

  Future<MessageModel> sendMessage(String chatId, String text) async {
    final data =
        await _post('/chats/$chatId/messages', {'text': text});
    return MessageModel.fromJson(data['message'] ?? data);
  }

  Future<void> markMessagesRead(String chatId) async {
    await _post('/chats/$chatId/read');
  }

  // ─── Insights ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getInsights() async {
    final data = await _get('/insights');
    return Map<String, dynamic>.from(data);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
