import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

class ColorData {
  final String name;
  final Color color;

  const ColorData(this.name, this.color);
}

class ColorSelector extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const ColorData('Noir', Colors.black),
      const ColorData('Blanc', Colors.white),
      const ColorData('Beige', Color(0xFFE8DCC4)),
      const ColorData('Bleu', Color(0xFF2B4C7E)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Couleur',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: colors.map((c) {
                final isSelected = c.color == selectedColor;
                return GestureDetector(
                  onTap: () => onColorSelected(c.color),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: c.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.textPrimary : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
