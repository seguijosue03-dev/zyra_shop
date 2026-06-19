import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/notifications/domain/entities/notification_entity.dart';

class NotificationFilterChips extends StatelessWidget {
  final NotificationCategory selectedCategory;
  final ValueChanged<NotificationCategory> onCategorySelected;

  const NotificationFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: NotificationCategory.values.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_getCategoryName(category), style: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500)),
              selected: isSelected,
              onSelected: (val) {
                if (val) onCategorySelected(category);
              },
              selectedColor: Colors.black87,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.black.withOpacity(0.1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getCategoryName(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.all: return 'Toutes';
      case NotificationCategory.orders: return 'Commandes';
      case NotificationCategory.promotions: return 'Promotions';
      case NotificationCategory.sellers: return 'Vendeurs';
      case NotificationCategory.system: return 'Système';
    }
  }
}
