import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/notifications/domain/entities/notification_entity.dart';
import 'package:zyra_shop/features/notifications/presentation/state/mock_notifications_state.dart';
import 'package:zyra_shop/features/notifications/presentation/widgets/notification_card.dart';
import 'package:zyra_shop/features/notifications/presentation/widgets/notification_filter_chips.dart';
import 'package:zyra_shop/shared/widgets/empty_state_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

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
        title: Text('Notifications', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          ListenableBuilder(
            listenable: MockNotificationsState(),
            builder: (context, _) {
              final unreadCount = MockNotificationsState().unreadCount;
              if (unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => MockNotificationsState().markAllAsRead(),
                child: Text('Tout lire', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueAccent)),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          NotificationFilterChips(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() => _selectedCategory = category);
            },
          ),
          Container(height: 1, color: Colors.black.withOpacity(0.05)),
          Expanded(
            child: ListenableBuilder(
              listenable: MockNotificationsState(),
              builder: (context, _) {
                final allNotifications = MockNotificationsState().notifications;
                final filteredList = _selectedCategory == NotificationCategory.all
                    ? allNotifications
                    : allNotifications.where((n) => n.category == _selectedCategory).toList();

                if (filteredList.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(notification: filteredList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget(
      title: 'Aucune notification',
      message: 'Vous êtes à jour.',
      icon: Icons.notifications_off_outlined,
    );
  }
}
