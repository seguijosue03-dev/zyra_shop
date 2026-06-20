import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/products/domain/entities/product.dart';
import '../widgets/product_gallery.dart';
import '../widgets/product_info.dart';
import '../widgets/size_selector.dart';
import '../widgets/color_selector.dart';
import '../widgets/stock_indicator.dart';
import '../widgets/product_description.dart';
import '../widgets/seller_profile_section.dart';
import '../widgets/product_reviews.dart';
import '../widgets/recommended_products.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/quantity_selector.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String heroTagPrefix;

  const ProductDetailScreen({super.key, required this.product, this.heroTagPrefix = ''});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = 'M';
  Color _selectedColor = Colors.black;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ProductGallery(
                  productId: '${widget.heroTagPrefix}${widget.product.id}',
                  images: [
                    widget.product.imageUrl,
                    // Mock extra images
                    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=400',
                    'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=400',
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductInfo(product: widget.product),
                          const SizedBox(height: 24),
                          SizeSelector(
                            selectedSize: _selectedSize,
                            onSizeSelected: (size) => setState(() => _selectedSize = size),
                          ),
                          const SizedBox(height: 24),
                          ColorSelector(
                            selectedColor: _selectedColor,
                            onColorSelected: (color) => setState(() => _selectedColor = color),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quantité',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                QuantitySelector(
                                  quantity: _quantity,
                                  onChanged: (val) => setState(() => _quantity = val),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const StockIndicator(status: StockStatus.inStock),
                          const SizedBox(height: 24),
                          const ProductDescription(),
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.divider, thickness: 8),
                          const SizedBox(height: 24),
                          SellerProfileSection(product: widget.product),
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.divider, thickness: 8),
                          const SizedBox(height: 24),
                          const ProductReviews(),
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.divider, thickness: 8),
                          const SizedBox(height: 24),
                          const RecommendedProducts(),
                          const SizedBox(height: 100), // Space for bottom action bar
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Transparent App Bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconBtn(Icons.arrow_back, () => Navigator.pop(context)),
                    _buildIconBtn(Icons.share_outlined, () {}),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomActionBar(
              product: widget.product,
              selectedSize: _selectedSize,
              selectedColor: _selectedColor,
              quantity: _quantity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }
}
