import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

class ProductReviews extends StatelessWidget {
  const ProductReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avis clients',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Voir tout',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReviewItem(
            name: 'Julie M.',
            rating: 5,
            date: 'Il y a 2 jours',
            comment: 'La qualité est incroyable, je recommande à 100%. La taille correspond parfaitement.',
          ),
          const SizedBox(height: 16),
          _buildReviewItem(
            name: 'Sarah K.',
            rating: 4,
            date: 'Il y a 1 semaine',
            comment: 'Très beau design, la couleur est fidèle à la photo. Légèrement grand mais très confortable.',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required int rating,
    required String date,
    required String comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              date,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star_rounded,
              color: index < rating ? AppColors.warning : AppColors.border,
              size: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          comment,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
