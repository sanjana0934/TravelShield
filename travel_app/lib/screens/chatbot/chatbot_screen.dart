// lib/screens/chatbot/chatbot_screen.dart

import 'package:flutter/material.dart';
import '../../models/chat_message_model.dart';
import '../../services/chatbot_service.dart';
import '../../widgets/chat_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isTyping = false;
  String? _userLocation;

  static const List<Map<String, String>> _quickSuggestions = [
    {'icon': '🛡️', 'label': 'Safety tips'},
    {'icon': '🏖️', 'label': 'Best places in Kerala'},
    {'icon': '🍛', 'label': 'Food near me'},
    {'icon': '🏨', 'label': 'Hotels near me'},
    {'icon': '🗺️', 'label': 'Travel advice'},
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text:
            'Hello 👋 I am TravelShield AI, your Kerala travel assistant!\n\nI can help you with:\n• 🛡️ Safety tips & emergency guidance\n• 🏖️ Best places to visit\n• 🍛 Food & restaurant recommendations\n• 🏨 Hotels & homestay suggestions\n• 🗺️ Travel planning advice\n\nAsk me anything about Kerala tourism. Namaskaram! 🙏',
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _addMessage(ChatMessage message) {
    setState(() => _messages.add(message));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isTyping) return;

    _inputController.clear();
    _focusNode.unfocus();

    _addMessage(ChatMessage(
      text: trimmed,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    ));

    setState(() => _isTyping = true);
    _scrollToBottom();

    try {
      final reply = await ChatbotService.sendMessage(
        message: trimmed,
        location: _userLocation,
      );
      _addMessage(ChatMessage(
        text: reply,
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
      ));
    } on ChatbotException catch (e) {
      _addMessage(ChatMessage(
        text: 'Oops! ${e.message}',
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
        isError: true,
      ));
    } catch (_) {
      _addMessage(ChatMessage(
        text: 'Something went wrong. Please try again later.',
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
        isError: true,
      ));
    } finally {
      setState(() => _isTyping = false);
      _scrollToBottom();
    }
  }

  void _showLocationDialog() {
    final locationController = TextEditingController(text: _userLocation ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF2E7D32)),
            SizedBox(width: 8),
            Text('Set Your Location',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20))),
          ],
        ),
        content: TextField(
          controller: locationController,
          decoration: InputDecoration(
            hintText: 'e.g. Fort Kochi, Munnar, Wayanad...',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
            prefixIcon:
                const Icon(Icons.place_outlined, color: Color(0xFF2E7D32)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _userLocation = null);
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                _userLocation = locationController.text.trim().isEmpty
                    ? null
                    : locationController.text.trim();
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          if (_isTyping) const TypingIndicator(),
          _buildQuickSuggestionsRow(),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: const Padding(
        padding: EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundColor: Colors.white24,
          child: Text('🛡️', style: TextStyle(fontSize: 18)),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TravelShield AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            _userLocation != null
                ? '📍 $_userLocation'
                : 'Kerala Tourism Assistant',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            _userLocation != null ? Icons.location_on : Icons.location_off,
            color:
                _userLocation != null ? Colors.greenAccent : Colors.white70,
          ),
          tooltip: 'Set location',
          onPressed: _showLocationDialog,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return ChatBubble(message: _messages[index]);
      },
    );
  }

  Widget _buildQuickSuggestionsRow() {
    if (_messages.length > 1 && !_isTyping) return const SizedBox.shrink();

    return Container(
      color: const Color(0xFFF1F8E9),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _quickSuggestions.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final s = _quickSuggestions[i];
            return GestureDetector(
              onTap: () => _sendMessage(s['label']!),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF81C784)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(s['icon']!, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 5),
                    Text(
                      s['label']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      color: const Color(0xFFF1F8E9),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _inputController,
                focusNode: _focusNode,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                  fontFamily: 'Georgia',
                ),
                decoration: const InputDecoration(
                  hintText: 'Ask about Kerala travel…',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_inputController.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}