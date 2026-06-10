import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

enum StockStatus { inStock, lowStock, outOfStock }

class StockIndicator extends StatelessWidget {
  final StockStatus status;

  const StockIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    Color bgColor;

    switch (status) {
      case StockStatus.inStock:
        text = 'En stock';
        color = AppColors.success;
        bgColor = AppColors.successSurface;
        break;
      case StockStatus.lowStock:
        text = 'Stock faible';
        color = AppColors.warning;
        bgColor = const Color(0xFFFEF3C7);
        break;
      case StockStatus.outOfStock:
        text = 'Rupture de stock';
        color = AppColors.error;
        bgColor = AppColors.errorSurface;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
