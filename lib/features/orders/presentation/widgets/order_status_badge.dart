import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import '../../domain/entities/order_mock.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case OrderStatus.delivered:
        bgColor = const Color(0xFFE8F5E9); // Light Green
        textColor = const Color(0xFF2E7D32); // Dark Green
        label = 'Livrée';
        break;
      case OrderStatus.preparing:
        bgColor = const Color(0xFFFFF3E0); // Light Orange
        textColor = const Color(0xFFE65100); // Dark Orange
        label = 'En préparation';
        break;
      case OrderStatus.shipped:
        bgColor = const Color(0xFFE3F2FD); // Light Blue
        textColor = const Color(0xFF1565C0); // Dark Blue
        label = 'Expédiée';
        break;
      case OrderStatus.delivering:
        bgColor = const Color(0xFFE3F2FD); // Light Blue
        textColor = const Color(0xFF1565C0); // Dark Blue
        label = 'En cours';
        break;
      case OrderStatus.cancelled:
        bgColor = const Color(0xFFFFEBEE); // Light Red
        textColor = const Color(0xFFC62828); // Dark Red
        label = 'Annulée';
        break;
      case OrderStatus.confirmed:
      default:
        bgColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        label = 'Confirmée';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
