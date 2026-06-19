import 'package:flutter/material.dart';

enum MessageType {
  text,
  productShare,
  orderStatus,
}

class MessageEntity {
  final String id;
  final String senderId; // 'me' or other
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;
  
  // For product sharing
  final Map<String, dynamic>? productData;
  
  // For order status
  final String? orderStatusLabel;
  final Color? orderStatusColor;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.isRead = false,
    this.productData,
    this.orderStatusLabel,
    this.orderStatusColor,
  });
}
