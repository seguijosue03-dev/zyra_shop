import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/notifications/domain/entities/notification_entity.dart';
import 'package:zyra_shop/features/notifications/presentation/screens/notification_details_screen.dart';
import 'package:zyra_shop/features/notifications/presentation/state/mock_notifications_state.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.redAccent,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        MockNotificationsState().deleteNotification(notification.id);
      },
      child: InkWell(
        onTap: () {
          MockNotificationsState().markAsRead(notification.id);
          Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationDetailsScreen(notification: notification)));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.blue.withOpacity(0.03),
            border: Border(
              bottom: BorderSide(color: Colors.black.withOpacity(0.03)),
              left: BorderSide(
                color: notification.isRead ? Colors.transparent : Colors.blueAccent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(notification.date),
                          style: GoogleFonts.inter(fontSize: 12, color: notification.isRead ? Colors.black45 : Colors.blueAccent, fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.description,
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.black54, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!notification.isRead) ...[
                const SizedBox(width: 12),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (notification.category) {
      case NotificationCategory.orders:
        iconData = Icons.local_shipping_outlined;
        iconColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.1);
        break;
      case NotificationCategory.promotions:
        iconData = Icons.sell_outlined;
        iconColor = Colors.pinkAccent;
        bgColor = Colors.pinkAccent.withOpacity(0.1);
        break;
      case NotificationCategory.sellers:
        iconData = Icons.storefront_outlined;
        iconColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        break;
      case NotificationCategory.system:
        iconData = Icons.settings_outlined;
        iconColor = Colors.black54;
        bgColor = Colors.grey.shade200;
        break;
      default:
        iconData = Icons.notifications_none;
        iconColor = Colors.black54;
        bgColor = Colors.grey.shade200;
    }

    if (notification.isRead) {
      iconColor = Colors.black45;
      bgColor = Colors.grey.shade100;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else {
      return 'Il y a ${difference.inDays} j';
    }
  }
}
