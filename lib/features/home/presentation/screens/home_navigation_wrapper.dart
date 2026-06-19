import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import 'package:zyra_shop/core/state/app_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../widgets/mock_products.dart';
import '../widgets/product_card.dart';
import 'home_feed_view.dart';
import 'package:zyra_shop/features/checkout/presentation/screens/checkout_address_screen.dart' as zyra_checkout;
import 'package:zyra_shop/features/orders/presentation/screens/orders_list_screen.dart' as zyra_orders;
import 'package:zyra_shop/features/search/presentation/screens/search_screen.dart' as zyra_search;
import 'package:zyra_shop/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:zyra_shop/features/profile/presentation/screens/payment_methods_screen.dart';
import 'package:zyra_shop/features/profile/presentation/screens/settings_screen.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_seller_state.dart';
import 'package:zyra_shop/features/seller/presentation/screens/onboarding/seller_registration_screen.dart';
import 'package:zyra_shop/features/seller/presentation/screens/onboarding/seller_pending_approval_screen.dart';
import 'package:zyra_shop/features/seller/presentation/screens/onboarding/seller_contract_screen.dart';
import 'package:zyra_shop/features/seller/presentation/screens/dashboard/seller_dashboard_wrapper.dart';
import 'package:zyra_shop/shared/widgets/empty_state_widget.dart';

/// Manages tab switching, shared favorite items state, mock cart items state, and full French sub-views.
class HomeNavigationWrapper extends StatefulWidget {
  const HomeNavigationWrapper({super.key});

  @override
  State<HomeNavigationWrapper> createState() => _HomeNavigationWrapperState();
}

class _HomeNavigationWrapperState extends State<HomeNavigationWrapper> {
  int _currentIndex = 0;

  // Category filter state passed back to Accueil
  String _initialCategoryFilter = 'Tous';
  
  // Favorites filter states
  String _favoritesCategoryFilter = 'Tous';
  bool _showOutOfStockFavorites = false;

  // Cart interaction states
  int _cartTabIndex = 0;
  final Set<String> _unselectedCartItemKeys = {};

  void _goToHomeWithCategory(String category) {
    setState(() {
      _initialCategoryFilter = category;
      _currentIndex = 0; // Switch to Accueil
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // 0. Home Feed (Accueil)
      HomeFeedView(
        key: ValueKey('home_feed_$_initialCategoryFilter'),
      ),

      // 1. Categories Grid (Catégories)
      _buildCategoriesPage(),

      // 2. Favorites Grid (Favoris)
      _buildFavoritesPage(),

      // 3. Cart View (Panier)
      _buildCartPage(),

      // 4. Profile Dashboard (Profil)
      _buildProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFD1D5DB), width: 1.2),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                _buildBottomItem(0, Icons.home_outlined, Icons.home_rounded, 'Accueil'),
                _buildBottomItem(1, Icons.grid_view_outlined, Icons.grid_view_rounded, 'Catégories'),
                _buildBottomItem(2, Icons.favorite_outline, Icons.favorite_rounded, 'Favoris'),
                _buildBottomItem(3, Icons.shopping_bag_outlined, Icons.shopping_bag_rounded, 'Panier'),
                _buildBottomItem(4, Icons.person_outline, Icons.person_rounded, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomItem(int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    final isSelected = _currentIndex == index;
    final icon = isSelected ? selectedIcon : unselectedIcon;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (index != 0) {
              _initialCategoryFilter = 'Tous';
            }
            _currentIndex = index;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dummy full-height container to force Stack to take full height of the navbar item (68px)
            const SizedBox(
              height: 68,
              width: double.infinity,
            ),

            // Icon and Text
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: isSelected ? 24 : 22,
                    color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            // Top purple indicator for selected tab
            if (isSelected)
              Positioned(
                top: 0,
                child: Container(
                  width: 24,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Tab 1: Categories Page ──────────────────────────────────────────────────
  Widget _buildCategoriesPage() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Catégories', style: AppTextStyles.headlineLarge),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1.2),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: mockCategories.length,
        itemBuilder: (context, index) {
          final category = mockCategories[index];
          return GestureDetector(
            onTap: () => _goToHomeWithCategory(category.name),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.01),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Tab 2: Favorites Page ───────────────────────────────────────────────────
  Widget _buildFavoritesPage() {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final List<Product> allFavoriteProducts = mockProducts
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
                onPressed: () {
                  setState(() => _currentIndex = 3);
                }
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sélecteur de collections (bientôt disponible)')),
                          );
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
                onPressed: () => setState(() => _currentIndex = 0),
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

  // ── Tab 3: Cart Page ────────────────────────────────────────────────────────
  Widget _buildCartPage() {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final List<CartItemMock> cartItems = AppState().cartItems;
        
        // Calculate selected count and total based on unselected keys
        int selectedCount = 0;
        double selectedTotal = 0;
        for (var item in cartItems) {
          final key = '${item.product.id}_${item.size}_${item.color.value}';
          if (!_unselectedCartItemKeys.contains(key)) {
            selectedCount++;
            selectedTotal += item.product.price * item.quantity;
          }
        }
        final bool isAllSelected = selectedCount == cartItems.length && cartItems.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87), 
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(AppState().shippingAddressName ?? 'Mon Panier', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    if (AppState().shippingAddressName != null) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black87),
                    ]
                  ],
                ),
                if (AppState().shippingAddressLocation != null)
                  Text(AppState().shippingAddressLocation!, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.black87), 
                onPressed: () => setState(() => _currentIndex = 2),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildCartTab('Articles', 0),
                        _buildCartTab('Coupons & Offres', 1),
                        _buildCartTab('ZYRA Currency', 2),
                      ],
                    ),
                  ),
                  Container(height: 1, color: AppColors.border),
                ],
              ),
            ),
          ),
          body: cartItems.isEmpty
              ? EmptyStateWidget(
                  title: 'Votre panier est vide',
                  message: 'Découvrez nos produits et ajoutez-les à votre panier.',
                  icon: Icons.shopping_bag_outlined,
                  actionLabel: 'Faire mes achats',
                  onActionPressed: () => setState(() => _currentIndex = 0),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Header
                          Text('Votre Panier', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isAllSelected) {
                                      // Unselect all
                                      for (var item in cartItems) {
                                        _unselectedCartItemKeys.add('${item.product.id}_${item.size}_${item.color.value}');
                                      }
                                    } else {
                                      // Select all
                                      _unselectedCartItemKeys.clear();
                                    }
                                  });
                                },
                                child: Icon(
                                  isAllSelected ? Icons.check_box : Icons.check_box_outline_blank, 
                                  color: isAllSelected ? AppColors.primary : Colors.grey.shade500, 
                                  size: 20
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('$selectedCount/${cartItems.length} Articles sélectionnés', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (selectedCount > 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Partage de $selectedCount article(s)...'), duration: const Duration(seconds: 1)));
                                  }
                                },
                                child: Icon(Icons.share_outlined, size: 20, color: Colors.grey.shade700),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  if (selectedCount > 0) {
                                    final indicesToRemove = <int>[];
                                    for (int i = 0; i < cartItems.length; i++) {
                                      final item = cartItems[i];
                                      final key = '${item.product.id}_${item.size}_${item.color.value}';
                                      if (!_unselectedCartItemKeys.contains(key)) {
                                        indicesToRemove.add(i);
                                      }
                                    }
                                    AppState().removeItemsFromCart(indicesToRemove);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$selectedCount article(s) supprimé(s)'), duration: const Duration(seconds: 1)));
                                    setState(() {
                                      _unselectedCartItemKeys.clear();
                                    });
                                  }
                                },
                                child: Icon(Icons.delete_outline, size: 20, color: Colors.grey.shade700),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  if (selectedCount > 0) {
                                    final productIdsToFavorite = <String>[];
                                    for (int i = 0; i < cartItems.length; i++) {
                                      final item = cartItems[i];
                                      final key = '${item.product.id}_${item.size}_${item.color.value}';
                                      if (!_unselectedCartItemKeys.contains(key)) {
                                        productIdsToFavorite.add(item.product.id);
                                      }
                                    }
                                    AppState().addItemsToFavorites(productIdsToFavorite);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$selectedCount article(s) ajouté(s) aux favoris'), duration: const Duration(seconds: 1)));
                                  } else {
                                    setState(() => _currentIndex = 2);
                                  }
                                },
                                child: Icon(Icons.favorite_border, size: 20, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Items
                          ...cartItems.asMap().entries.map((entry) {
                            return _buildMyntraCartItem(entry.key, entry.value, _unselectedCartItemKeys);
                          }),
                        ],
                      ),
                    ),
                    
                    // Checkout Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (selectedCount == 0)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFFE5E5), Color(0xFFFFCCCC)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Text(
                                  'Aucun article sélectionné, veuillez sélectionner au moins un article.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                                ),
                              ),
                            if (selectedCount > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total estimé',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '${selectedTotal.toStringAsFixed(0)} FCFA',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedCount > 0 ? AppColors.primary : Colors.grey.shade400,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 0,
                                  ),
                                  onPressed: selectedCount > 0 ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const zyra_checkout.CheckoutAddressScreen()),
                                    );
                                  } : null,
                                  child: Text('Passer la commande', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCartTab(String title, int index) {
    bool isSelected = _cartTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _cartTabIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  void _showQtySelector(BuildContext context, int index, CartItemMock item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Sélectionnez la quantité', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, i) {
                    final qty = i + 1;
                    return ListTile(
                      title: Text('$qty', style: GoogleFonts.inter(fontWeight: qty == item.quantity ? FontWeight.bold : FontWeight.normal)),
                      trailing: qty == item.quantity ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () {
                        AppState().updateCartQuantity(index, qty);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSizeSelector(BuildContext context, int index, CartItemMock item) {
    final sizes = ['S', 'M', 'L', 'XL', 'XXL'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Sélectionnez la taille', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ...sizes.map((s) => ListTile(
                title: Text(s, style: GoogleFonts.inter(fontWeight: s == item.size ? FontWeight.bold : FontWeight.normal)),
                trailing: s == item.size ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  AppState().updateCartSize(index, s);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyntraCartItem(int index, CartItemMock item, Set<String> unselectedKeys) {
    final product = item.product;
    final brand = product.category.toUpperCase();
    final oldPrice = product.oldPrice ?? (product.price * 1.6);
    final discountPercent = (((oldPrice - product.price) / oldPrice) * 100).round();
    
    final String itemKey = '${product.id}_${item.size}_${item.color.value}';
    final bool isChecked = !unselectedKeys.contains(itemKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox and Image
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8, top: 8),
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isChecked) {
                              unselectedKeys.add(itemKey);
                            } else {
                              unselectedKeys.remove(itemKey);
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent, // expand tap area
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            isChecked ? Icons.check_box : Icons.check_box_outline_blank, 
                            color: isChecked ? AppColors.primary : Colors.black54, 
                            size: 20
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(brand, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                          GestureDetector(
                            onTap: () {
                              AppState().removeFromCart(index);
                              // Auto unselect key to keep count clean if we wanted to, 
                              // but since the item isn't rendered, it won't be counted anyway
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Article retiré du panier'), duration: Duration(seconds: 1)));
                            },
                            child: const Icon(Icons.close, size: 18, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Size Selector
                          GestureDetector(
                            onTap: () => _showSizeSelector(context, index, item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Text('Taille: ${item.size}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.black87),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Qty Selector
                          GestureDetector(
                            onTap: () => _showQtySelector(context, index, item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Text('Qté: ${item.quantity}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.black87),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('1 left', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade400)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${product.price.toStringAsFixed(0)} FCFA', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(width: 6),
                          Text(
                            '${oldPrice.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500, decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(width: 6),
                          Text('$discountPercent% Off', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.orange.shade400)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.keyboard_return, size: 12, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text('Retour sous 7 jours', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProfilePage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Profil', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54, size: 20),
          onPressed: () => setState(() => _currentIndex = 0),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Pink Wave Band Background
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              height: 180,
              child: ClipPath(
                clipper: _ProfileBandClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, const Color(0xFFE91E63)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ),
            
            // Content
            Column(
              children: [
                const SizedBox(height: 10),
                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(Icons.person, size: 60, color: Colors.grey.shade300),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Mon Profil', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text('Bienvenue sur ZYRA', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
                const SizedBox(height: 40),
                
                // My Orders Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mes Commandes', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 28),
                        // 3x2 Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOrderGridItem(Icons.account_balance_wallet, 'Paiement\nen attente', Colors.lightBlue, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_orders.OrdersListScreen()));
                            }),
                            _buildOrderGridItem(Icons.local_shipping, 'Livré', Colors.amber.shade600, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_orders.OrdersListScreen()));
                            }),
                            _buildOrderGridItem(Icons.shopping_basket, 'En cours', AppColors.primary, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_orders.OrdersListScreen()));
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOrderGridItem(Icons.inventory, 'Annulé', Colors.green, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_orders.OrdersListScreen()));
                            }),
                            _buildOrderGridItem(Icons.favorite, 'Favoris', const Color(0xFFFF4B72), () {
                              setState(() => _currentIndex = 2);
                            }),
                            _buildOrderGridItem(Icons.headset_mic, 'Service\nClient', Colors.deepPurple.shade400, () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service Client (Mock)')));
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // List options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildProfileListTile(Icons.person_outline, 'Modifier le profil', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                      }),
                      _buildProfileListTile(Icons.location_on_outlined, 'Adresses de livraison', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const zyra_checkout.CheckoutAddressScreen()),
                        );
                      }),
                      _buildProfileListTile(Icons.payment_outlined, 'Modes de paiement', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()));
                      }),
                      _buildProfileListTile(Icons.settings_outlined, 'Paramètres', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                      }),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                      _buildProfileListTile(Icons.storefront_outlined, 'Espace Vendeur', () {
                        final status = MockSellerState().status;
                        if (status == SellerStatus.none) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerRegistrationScreen()));
                        } else if (status == SellerStatus.pending) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerPendingApprovalScreen()));
                        } else if (status == SellerStatus.contractRequired) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerContractScreen()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerDashboardWrapper()));
                        }
                      }, iconColor: const Color(0xFFFF4B72)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Logout
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 600),
                        pageBuilder: (ctx, animation, _) => const LoginScreen(),
                        transitionsBuilder: (ctx, animation, _, child) => FadeTransition(
                          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                          child: child,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text('Se déconnecter', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderGridItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                // Use a soft gradient or drop shadow like the screenshot
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileListTile(IconData icon, String title, VoidCallback onTap, {Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.grey.shade500, size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }
}

class _ProfileBandClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 40);
    path.quadraticBezierTo(size.width * 0.5, 120, size.width, 0);
    path.lineTo(size.width, size.height - 40);
    path.quadraticBezierTo(size.width * 0.5, size.height + 40, 0, size.height - 80);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
                      '${product.price.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${displayOldPrice.toStringAsFixed(0)}',
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
