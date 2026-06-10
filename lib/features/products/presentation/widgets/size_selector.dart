import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

class SizeSelector extends StatelessWidget {
  final String selectedSize;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = ['S', 'M', 'L', 'XL', 'XXL'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Taille',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Guide des tailles',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: sizes.map((size) {
                final isSelected = size == selectedSize;
                return GestureDetector(
                  onTap: () => onSizeSelected(size),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      size,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
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
