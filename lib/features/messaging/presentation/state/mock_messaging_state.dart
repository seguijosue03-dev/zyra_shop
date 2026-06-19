import 'package:flutter/material.dart';
import 'package:zyra_shop/features/messaging/domain/entities/conversation_entity.dart';
import 'package:zyra_shop/features/messaging/domain/entities/message_entity.dart';

class MockMessagingState extends ChangeNotifier {
  static final MockMessagingState _instance = MockMessagingState._internal();
  factory MockMessagingState() => _instance;

  MockMessagingState._internal() {
    _initMockData();
  }

  List<ConversationEntity> _conversations = [];
  List<ConversationEntity> get conversations => _conversations;

  int get globalUnreadCount => _conversations.fold(0, (sum, conv) => sum + conv.unreadCount);

  void _initMockData() {
    _conversations = [];
  }

  void markConversationAsRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      bool changed = false;
      for (var msg in _conversations[index].messages) {
        if (!msg.isRead && msg.senderId != 'me') {
          msg = MessageEntity(
            id: msg.id,
            senderId: msg.senderId,
            text: msg.text,
            timestamp: msg.timestamp,
            type: msg.type,
            isRead: true,
            productData: msg.productData,
            orderStatusLabel: msg.orderStatusLabel,
            orderStatusColor: msg.orderStatusColor,
          );
          changed = true;
        }
      }
      if (changed) notifyListeners();
    }
  }

  void sendMessage(String conversationId, String text, {MessageType type = MessageType.text, Map<String, dynamic>? productData}) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index].messages.add(
        MessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'me',
          text: text,
          timestamp: DateTime.now(),
          type: type,
          isRead: false,
          productData: productData,
        ),
      );
      // Sort conversation to top (simulated by re-inserting)
      final conv = _conversations.removeAt(index);
      _conversations.insert(0, conv);
      notifyListeners();
    }
  }

  // Create or get conversation for a specific seller/product
  String getOrCreateConversation(String partnerName) {
    final index = _conversations.indexWhere((c) => c.partnerName == partnerName);
    if (index != -1) return _conversations[index].id;
    
    final newId = 'c_${DateTime.now().millisecondsSinceEpoch}';
    _conversations.insert(0, ConversationEntity(
      id: newId,
      partnerId: 'p_$newId',
      partnerName: partnerName,
      partnerAvatarText: partnerName.isNotEmpty ? partnerName[0].toUpperCase() : 'S',
      isOnline: true,
      isSeller: true,
      messages: [],
    ));
    notifyListeners();
    return newId;
  }
}
