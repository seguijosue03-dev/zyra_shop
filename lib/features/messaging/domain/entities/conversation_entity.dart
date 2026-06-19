import 'package:zyra_shop/features/messaging/domain/entities/message_entity.dart';

class ConversationEntity {
  final String id;
  final String partnerId;
  final String partnerName;
  final String partnerAvatarText;
  final bool isOnline;
  final bool isSeller;
  
  List<MessageEntity> messages;

  ConversationEntity({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    required this.partnerAvatarText,
    required this.isOnline,
    required this.isSeller,
    required this.messages,
  });

  MessageEntity? get lastMessage => messages.isNotEmpty ? messages.last : null;
  int get unreadCount => messages.where((m) => m.senderId != 'me' && !m.isRead).length;
}
