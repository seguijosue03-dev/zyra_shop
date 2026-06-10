import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/home/presentation/widgets/mock_products.dart';
import 'package:zyra_shop/core/state/app_state.dart';

class BottomActionBar extends StatelessWidget {
  final Product product;
  final String selectedSize;
  final Color selectedColor;

  const BottomActionBar({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            ListenableBuilder(
              listenable: AppState(),
              builder: (context, _) {
                final isFavorite = AppState().isFavorite(product.id);
                return GestureDetector(
                  onTap: () => AppState().toggleFavorite(product.id),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: isFavorite ? const Color(0xFFFF4B72) : AppColors.border, width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? const Color(0xFFFF4B72) : AppColors.textPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradientDiagonal,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      AppState().addToCart(product, selectedSize, selectedColor);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Produit ajouté au panier'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Ajouter au panier',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
}
