import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'mock_products.dart';

/// ZYRA Shop — Premium Product Card
/// Redesigned: shadow-only depth, full-width CTA, strikethrough pricing, no creator row.
class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;
  final bool showName;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
    this.showName = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 172,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ─────────────────────────────
            Stack(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: AspectRatio(
                    aspectRatio: 0.80,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFF8F9FB),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 36,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Discount Badge (Top Left)
                if (product.hasDiscount)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4B72),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '-${product.discountPercentage}%',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                // Favorite Button (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 17,
                        color: isFavorite
                            ? const Color(0xFFFF4B72)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Info Area ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name (Conditional)
                  if (showName) ...[
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],

                  // 5 Star Rating Row
                  Row(
                    children: List.generate(5, (index) {
                      return const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFFFC107),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),

                  // Price Row (Side-by-side)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (product.hasDiscount) ...[
                        Text(
                          _formatPrice(product.oldPrice!, isOldPrice: true),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF9CA3AF),
                            decoration: TextDecoration.lineThrough,
                            decorationColor: const Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _formatPrice(product.price),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Full-Width CTA Button ───────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} ajouté au panier'),
                      duration: const Duration(milliseconds: 800),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                },
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Ajouter au panier',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double val, {bool isOldPrice = false}) {
    if (val % 1 == 0) {
      return isOldPrice ? '${val.toInt()},0 €' : '${val.toInt()} €';
    } else {
      return '${val.toStringAsFixed(2).replaceAll('.', ',')} €';
    }
  }
}
