import 'package:flutter/material.dart';

enum NotificationCategory {
  all,
  orders,
  promotions,
  sellers,
  system
}

class NotificationEntity {
  final String id;
  final String title;
  final String description;
  final String fullDescription;
  final NotificationCategory category;
  final DateTime date;
  final String actionLabel;
  final VoidCallback? onActionTap;
  bool isRead;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.category,
    required this.date,
    required this.actionLabel,
    this.onActionTap,
    this.isRead = false,
  });
}
