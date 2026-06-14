import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

class SearchHistorySection extends StatelessWidget {
  final List<String> history;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const SearchHistorySection({
    super.key,
    required this.history,
    required this.onSearch,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recherches récentes',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onClearAll,
                child: Text(
                  'Effacer',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: history.map((term) => _buildHistoryChip(term)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryChip(String term) {
    return GestureDetector(
      onTap: () => onSearch(term),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_rounded, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              term,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onRemove(term),
              child: const Icon(Icons.close_rounded, size: 16, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
