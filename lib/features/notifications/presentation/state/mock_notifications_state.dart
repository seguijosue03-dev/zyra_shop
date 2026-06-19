import 'package:flutter/material.dart';
import 'package:zyra_shop/features/notifications/domain/entities/notification_entity.dart';

class MockNotificationsState extends ChangeNotifier {
  static final MockNotificationsState _instance = MockNotificationsState._internal();
  factory MockNotificationsState() => _instance;

  MockNotificationsState._internal() {
    _initMockData();
  }

  List<NotificationEntity> _notifications = [];

  List<NotificationEntity> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void _initMockData() {
    _notifications = [];
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
