import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/messaging/domain/entities/message_entity.dart';
import 'package:zyra_shop/features/messaging/presentation/state/mock_messaging_state.dart';
import 'package:zyra_shop/features/messaging/presentation/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MockMessagingState().markConversationAsRead(widget.conversationId);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    MockMessagingState().sendMessage(widget.conversationId, _controller.text.trim());
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _sendMockProduct() {
    MockMessagingState().sendMessage(
      widget.conversationId,
      '',
      type: MessageType.productShare,
      productData: {
        'name': 'Robe d\'été florale',
        'price': '45 000 FCFA',
        'image': 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?q=80&w=800'
      },
    );
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockMessagingState(),
      builder: (context, _) {
        final conv = MockMessagingState().conversations.firstWhere((c) => c.id == widget.conversationId);
        
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(conv.partnerAvatarText, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                    if (conv.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: Colors.greenAccent.shade400, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(conv.partnerName, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(conv.isOnline ? 'En ligne' : 'Hors ligne', style: GoogleFonts.inter(fontSize: 12, color: conv.isOnline ? Colors.green : Colors.black45)),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              if (conv.isSeller)
                IconButton(icon: const Icon(Icons.storefront_outlined, color: Colors.black87), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_vert, color: Colors.black87), onPressed: () {}),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xFFF9FAFB),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    itemCount: conv.messages.length,
                    itemBuilder: (context, index) {
                      final msg = conv.messages[index];
                      return MessageBubble(message: msg, isMe: msg.senderId == 'me');
                    },
                  ),
                ),
              ),
              _buildInputBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.black54),
              onPressed: _sendMockProduct, // Mocking an attachment/product share
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.black54),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: 'Écrire un message...',
                    hintStyle: GoogleFonts.inter(color: Colors.black45),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF111827),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
