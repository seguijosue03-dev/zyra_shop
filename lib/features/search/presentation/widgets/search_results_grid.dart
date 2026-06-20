import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/state/app_state.dart';
import 'package:zyra_shop/features/products/domain/entities/product.dart';
import 'package:zyra_shop/features/home/presentation/widgets/product_card.dart';
import 'package:zyra_shop/features/products/presentation/screens/product_detail_screen.dart';

class SearchResultsGrid extends StatelessWidget {
  final List<Product> products;

  const SearchResultsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            '${products.length} résultat${products.length > 1 ? 's' : ''}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.51,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListenableBuilder(
                listenable: AppState(),
                builder: (context, _) {
                  return ProductCard(
                    product: product,
                    isFavorite: AppState().isFavorite(product.id),
                    onFavoriteToggle: () => AppState().toggleFavorite(product.id),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
