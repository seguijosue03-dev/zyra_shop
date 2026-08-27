import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/state/app_state.dart';
import 'package:zyra_shop/features/home/presentation/widgets/mock_products.dart';
import 'package:zyra_shop/features/products/domain/entities/product.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_dashboard_state.dart';
import 'package:zyra_shop/features/search/presentation/screens/search_screen.dart' as zyra_search;

class WishlistScreen extends StatefulWidget {
  final VoidCallback onNavigateToCart;
  final VoidCallback onNavigateToHome;

  const WishlistScreen({
    super.key, 
    required this.onNavigateToCart,
    required this.onNavigateToHome,
  });

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _favoritesCategoryFilter = 'Tous';
  bool _showOutOfStockFavorites = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([AppState(), MockDashboardState()]),
      builder: (context, _) {
        final sellerProducts = MockDashboardState().products.map((p) {
          final imageList = p['images'] as List?;
          final imageUrl = p['imageUrl'] as String?;
          final priceStr = p['price']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '0';
          return Product(
            id: p['id'].toString(),
            name: p['name'] ?? 'Produit',
            price: double.tryParse(priceStr) ?? 0.0,
            rating: 5.0,
            ratingCount: 1,
            imageUrl: imageUrl ?? ((imageList != null && imageList.isNotEmpty)
                ? imageList.first
                : 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600'),
            category: p['category'] ?? 'TOUT',
          );
        }).toList();

        final allProducts = [...sellerProducts, ...mockProducts];

        final List<Product> allFavoriteProducts = allProducts
            .where((p) => AppState().favorites.contains(p.id))
            .toList();
            
        // 1. Get unique categories currently in favorites
        final Set<String> availableCategories = allFavoriteProducts.map((p) => p.category).toSet();
        
        // 2. Ensure current filter is valid, otherwise fallback to 'Tous'
        String effectiveCategoryFilter = _favoritesCategoryFilter;
        if (effectiveCategoryFilter != 'Tous' && !availableCategories.contains(effectiveCategoryFilter)) {
          effectiveCategoryFilter = 'Tous';
          // Safely sync the state back to 'Tous' after build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _favoritesCategoryFilter != 'Tous') {
              setState(() => _favoritesCategoryFilter = 'Tous');
            }
          });
        }
            
        // 3. Apply Filters
        List<Product> favoriteProducts = List.from(allFavoriteProducts);
        if (effectiveCategoryFilter != 'Tous') {
          favoriteProducts = favoriteProducts.where((p) => p.category == effectiveCategoryFilter).toList();
        }
        if (_showOutOfStockFavorites) {
          // Mock behavior: none of our mock products are out of stock, so this yields empty list
          favoriteProducts = [];
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            scrolledUnderElevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mes Favoris',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  '${favoriteProducts.length} articles',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary), 
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_search.SearchScreen()));
                }
              ),
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary), 
                onPressed: widget.onNavigateToCart,
              ),
            ],
          ),
          body: Column(
            children: [
              // Top buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: BorderSide(color: AppColors.border, width: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          _showCollectionsBottomSheet(context);
                        },
                        icon: const Icon(Icons.layers_outlined, size: 18),
                        label: Text('Collections', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _showOutOfStockFavorites ? AppColors.surface : Colors.white,
                          foregroundColor: _showOutOfStockFavorites ? AppColors.primary : AppColors.textPrimary,
                          side: BorderSide(
                            color: _showOutOfStockFavorites ? AppColors.primary : AppColors.border, 
                            width: 1
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          setState(() {
                            _showOutOfStockFavorites = !_showOutOfStockFavorites;
                          });
                        },
                        icon: const Icon(Icons.block_flipped, size: 18),
                        label: Text('En rupture', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Filter Chips
              Container(
                height: 48,
                color: Colors.white,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip(
                      'Tous', 
                      isSelected: effectiveCategoryFilter == 'Tous', 
                      onTap: () => setState(() => _favoritesCategoryFilter = 'Tous')
                    ),
                    ...(availableCategories.toList()..sort()).map((cat) => _buildFilterChip(
                      cat,
                      isSelected: effectiveCategoryFilter == cat,
                      onTap: () => setState(() => _favoritesCategoryFilter = cat),
                    )),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              
              // Content (Grid or Empty State)
              Expanded(
                child: favoriteProducts.isEmpty
                    ? _buildPremiumEmptyFavorites()
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.55,
                        ),
                        itemCount: favoriteProducts.length,
                        itemBuilder: (context, index) {
                          return _WishlistProductCard(product: favoriteProducts[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumEmptyFavorites() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Premium Icon Container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4B72).withValues(alpha: 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4B72).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 36,
                    color: Color(0xFFFF4B72),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Aucun coup de cœur',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Vos articles préférés s\'afficheront ici.\nCommencez à explorer notre collection premium.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              width: 220,
              height: 54,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradientDiagonal,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: widget.onNavigateToHome,
                child: Text(
                  'Découvrir la collection',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCollectionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Mes Collections', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.favorite, color: AppColors.primary),
                title: Text('Tous mes favoris', style: GoogleFonts.inter()),
                trailing: const Icon(Icons.check, color: AppColors.primary),
                onTap: () {
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text('Mode Été', style: GoogleFonts.inter()),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collection Mode Été sélectionnée')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text('Chaussures', style: GoogleFonts.inter()),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collection Chaussures sélectionnée')));
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nouvelle collection créée')));
                  },
                  icon: const Icon(Icons.add),
                  label: Text('Créer une collection', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _WishlistProductCard extends StatelessWidget {
  final Product product;

  const _WishlistProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    int discountPercent = 0;
    if (product.oldPrice != null && product.oldPrice! > product.price) {
      discountPercent = (((product.oldPrice! - product.price) / product.oldPrice!) * 100).round();
    } else {
      // Mock discount for display fidelity if not present
      discountPercent = 20; 
    }
    
    final displayOldPrice = product.oldPrice ?? (product.price * 1.25);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and floating icons
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: AppColors.surface),
                  ),
                ),
                // Delete Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => AppState().toggleFavorite(product.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.black87),
                    ),
                  ),
                ),
                // Rating badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${product.rating}',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.star, size: 10, color: Colors.teal),
                        const SizedBox(width: 4),
                        Container(width: 1, height: 10, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          product.ratingCount >= 1000 
                              ? '${(product.ratingCount / 1000).toStringAsFixed(1)}k' 
                              : '${product.ratingCount}',
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.price.toStringAsFixed(0),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      displayOldPrice.toStringAsFixed(0),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($discountPercent% OFF)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          // Add to Bag Button
          InkWell(
            onTap: () {
              AppState().addToCart(product, 'M', Colors.black, 1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ajouté au panier')),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                'AJOUTER AU PANIER',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
