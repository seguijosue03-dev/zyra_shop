import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/products/domain/entities/product.dart';
import 'package:zyra_shop/features/home/presentation/widgets/product_card.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate some mock promotional products for the frontend presentation
    final List<Product> promoProducts = List.generate(
      6,
      (index) => Product(
        id: 'promo_$index',
        name: 'Article en Promotion ${index + 1}',
        price: 15000.0 - (index * 1000),
        oldPrice: 15000.0,
        imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400&q=80',
        category: 'Mode',
        rating: 4.5,
        ratingCount: 120,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Promotions',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Promo Banner
            Container(
              width: double.infinity,
              height: 120,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF4B72), Color(0xFFFF8E53)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4B72).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(Icons.local_offer_rounded, size: 120, color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SOLDES EXCEPTIONNELS', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12)),
                        const SizedBox(height: 8),
                        Text("Jusqu'à -50%", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28, height: 1.1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: promoProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: promoProducts[index],
                    isFavorite: false,
                    onFavoriteToggle: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Produit ajouté aux favoris')),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
