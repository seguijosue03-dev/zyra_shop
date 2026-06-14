import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

class OrderTimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;
  final IconData icon;

  const OrderTimelineStep({
    super.key,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isActive = false,
    this.isLast = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isCompleted || isActive ? Colors.white : AppColors.textSecondary;
    final Color bgColor = isCompleted
        ? const Color(0xFF2E7D32) // Green for completed
        : isActive
            ? AppColors.primary // Purple for active
            : AppColors.surface; // Gray for inactive
            
    final Color borderColor = isCompleted ? const Color(0xFF2E7D32) : isActive ? AppColors.primary : AppColors.border;
    final Color lineColor = isCompleted ? const Color(0xFF2E7D32) : AppColors.border;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isCompleted ? Icons.check_rounded : icon,
                color: iconColor,
                size: 18,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: lineColor,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: isCompleted || isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isCompleted || isActive ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (!isLast) const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
