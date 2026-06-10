import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({super.key});

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedCrossFade(
            firstChild: Text(
              'Découvrez notre nouvelle collection avec cette pièce premium. Fabriquée avec des matériaux de haute qualité, elle offre un confort optimal tout en conservant une coupe moderne et élégante. Idéale pour toutes vos occasions.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              'Découvrez notre nouvelle collection avec cette pièce premium. Fabriquée avec des matériaux de haute qualité, elle offre un confort optimal tout en conservant une coupe moderne et élégante. Idéale pour toutes vos occasions.\n\n• Composition: 100% Coton premium\n• Coupe: Oversize\n• Entretien: Lavage en machine à 30°C\n• Designé à Paris, fabriqué avec soin.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? 'Voir moins' : 'Lire la suite',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
