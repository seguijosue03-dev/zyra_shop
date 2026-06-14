import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

class TrendingSearchesSection extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const TrendingSearchesSection({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final trendingTerms = [
      'Robes été',
      'Vestes cuir',
      'Jeans cargo',
      'T-shirts oversize',
      'Hoodies premium',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF4B72), size: 20),
              const SizedBox(width: 8),
              Text(
                'Tendances',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: trendingTerms.map((term) => _buildTrendingChip(term)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingChip(String term) {
    return GestureDetector(
      onTap: () => onSearch(term),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          term,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
