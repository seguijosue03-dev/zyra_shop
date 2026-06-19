import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/notifications/domain/entities/notification_entity.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationDetailsScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLargeIcon(),
              const SizedBox(height: 32),
              Text(
                notification.title,
                style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.2),
              ),
              const SizedBox(height: 12),
              Text(
                _formatDateLong(notification.date),
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              Container(height: 1, color: Colors.black.withOpacity(0.05)),
              const SizedBox(height: 32),
              Text(
                notification.fullDescription,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.black87, height: 1.6),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: notification.onActionTap ?? () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(notification.actionLabel, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeIcon() {
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
        iconColor = Colors.black87;
        bgColor = Colors.grey.shade100;
        break;
      default:
        iconData = Icons.notifications_none;
        iconColor = Colors.black87;
        bgColor = Colors.grey.shade100;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 32),
    );
  }

  String _formatDateLong(DateTime date) {
    // Basic formatting for mock
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
