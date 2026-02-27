import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

// ─── Data Classes ─────────────────────────────────────────────────────────────
class _Conversation {
  final String name, lastMsg, time;
  final int unread;
  final bool online;
  _Conversation({
    required this.name,
    required this.lastMsg,
    required this.time,
    this.unread = 0,
    this.online = false,
  });
}

class _Msg {
  final String sender, text;
  final bool isMe;
  final String time;
  _Msg({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.time,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class StudentChatScreen extends StatefulWidget {
  const StudentChatScreen({super.key});
  @override
  State<StudentChatScreen> createState() => _StudentChatScreenState();
}

class _StudentChatScreenState extends State<StudentChatScreen> {
  String? _activeConv;
  final List<_Msg> _currentMsgs = [];
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // API-loaded chats
  List<_Conversation> _apiConversations = [];
  Map<String, String> _chatIdMap = {}; // convName → chatId
  bool _loadingChats = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    try {
      final chats = await ApiService().getChats();
      _apiConversations = chats.map((c) {
        _chatIdMap[c.chatTitle] = c.chatId;
        return _Conversation(
          name: c.chatTitle.isNotEmpty ? c.chatTitle : 'Chat',
          lastMsg: c.lastMessage,
          time: _formatTime(c.lastUpdatedAt),
          unread: 0,
          online: c.status == 'Active',
        );
      }).toList();
    } catch (_) {}
    if (mounted) setState(() => _loadingChats = false);
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  void _openConv(String name) async {
    setState(() {
      _activeConv = name;
      _currentMsgs.clear();
    });

    // Load real messages from API
    final chatId = _chatIdMap[name];
    if (chatId != null) {
      try {
        final msgs = await ApiService().getMessages(chatId);
        if (msgs.isNotEmpty && mounted) {
          final uid = ApiService().uid;
          setState(() {
            _currentMsgs
              ..clear()
              ..addAll(msgs.map((m) => _Msg(
                    sender: m.senderId == uid ? 'You' : m.senderId,
                    text: m.text,
                    isMe: m.senderId == uid,
                    time: m.timestamp != null
                        ? '${m.timestamp!.hour.toString().padLeft(2, '0')}:${m.timestamp!.minute.toString().padLeft(2, '0')}'
                        : '',
                  )));
          });
        }
        await ApiService().markMessagesRead(chatId);
      } catch (_) {}
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _send() async {
    final txt = _msgCtrl.text.trim();
    if (txt.isEmpty) return;
    setState(() {
      _currentMsgs.add(
        _Msg(sender: 'You', text: txt, isMe: true, time: _now()),
      );
      _msgCtrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Try sending via API
    final chatId = _chatIdMap[_activeConv];
    if (chatId != null) {
      try {
        await ApiService().sendMessage(chatId, txt);
      } catch (_) {}
    }
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  String _now() {
    final t = DateTime.now();
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tc = isDark ? Colors.white : AppTheme.textPrimaryColor;
    final sc = isDark
        ? Colors.white60
        : AppTheme.primaryColor.withValues(alpha: 0.55);
    final bg = isDark ? const Color(0xFF111111) : const Color(0xFFF7F7F7);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          // ── Conversation List ──
          Container(
            width: 280,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Messages',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: tc,
                          ),
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Note about temp chat
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 13,
                          color: AppTheme.accentPurple,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Temporary chats — clears on logout',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.accentPurple.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // List
                Expanded(
                  child: ListView.builder(
                    itemCount: _apiConversations.length,
                    itemBuilder: (ctx, i) {
                      final conv = _apiConversations[i];
                      final isActive = _activeConv == conv.name;
                      return GestureDetector(
                        onTap: () => _openConv(conv.name),
                        child:
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      )
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: isActive
                                            ? AppTheme.primaryColor
                                            : AppTheme.secondaryColor,
                                        child: Text(
                                          conv.name[0],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (conv.online)
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.greenAccent,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isDark
                                                    ? const Color(0xFF111111)
                                                    : Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                conv.name,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: isActive
                                                      ? AppTheme.primaryColor
                                                      : tc,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              conv.time,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: sc,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                conv.lastMsg,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: sc,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (conv.unread > 0)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: const BoxDecoration(
                                                  color: AppTheme.primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '${conv.unread}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(
                              delay: Duration(milliseconds: 40 * i),
                              duration: 250.ms,
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Chat Area ──
          Expanded(
            child: _activeConv == null
                ? _EmptyState(isDark: isDark, tc: tc, sc: sc)
                : _ChatArea(
                    convName: _activeConv!,
                    messages: _currentMsgs,
                    msgCtrl: _msgCtrl,
                    scrollCtrl: _scrollCtrl,
                    isDark: isDark,
                    tc: tc,
                    sc: sc,
                    bg: bg,
                    onSend: _send,
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final Color tc, sc;
  const _EmptyState({required this.isDark, required this.tc, required this.sc});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.chat_bubble_outline_rounded,
          size: 48,
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.12),
        ),
        const SizedBox(height: 12),
        Text(
          'Select a conversation',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: tc,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pick a chat from the left to start messaging',
          style: TextStyle(fontSize: 13, color: sc),
        ),
      ],
    ),
  );
}

class _ChatArea extends StatelessWidget {
  final String convName;
  final List<_Msg> messages;
  final TextEditingController msgCtrl;
  final ScrollController scrollCtrl;
  final bool isDark;
  final Color tc, sc, bg;
  final VoidCallback onSend;
  const _ChatArea({
    required this.convName,
    required this.messages,
    required this.msgCtrl,
    required this.scrollCtrl,
    required this.isDark,
    required this.tc,
    required this.sc,
    required this.bg,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  convName[0],
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
                      convName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: tc,
                      ),
                    ),
                    Text(
                      'Temporary chat',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.accentPurple.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: Container(
            color: bg,
            child: ListView.builder(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (ctx, i) {
                final msg = messages[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: msg.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!msg.isMe) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.secondaryColor,
                          child: Text(
                            msg.sender[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Column(
                          crossAxisAlignment: msg.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (!msg.isMe)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(
                                  msg.sender,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white60
                                        : AppTheme.primaryColor.withValues(
                                            alpha: 0.6,
                                          ),
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              constraints: const BoxConstraints(maxWidth: 420),
                              decoration: BoxDecoration(
                                color: msg.isMe
                                    ? AppTheme.primaryColor
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : Colors.white),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(
                                    msg.isMe ? 16 : 4,
                                  ),
                                  bottomRight: Radius.circular(
                                    msg.isMe ? 4 : 16,
                                  ),
                                ),
                                boxShadow: msg.isMe
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: isDark ? 0.15 : 0.05,
                                          ),
                                          blurRadius: 4,
                                        ),
                                      ],
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: msg.isMe ? Colors.white : tc,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              msg.time,
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // Input bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111111) : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.07),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: msgCtrl,
                  style: TextStyle(fontSize: 14, color: tc),
                  onSubmitted: (_) => onSend(),
                  decoration: InputDecoration(
                    hintText: 'Message ${convName}…',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onSend,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
