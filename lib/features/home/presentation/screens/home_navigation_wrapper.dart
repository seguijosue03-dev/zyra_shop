import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../widgets/mock_products.dart';
import '../widgets/product_card.dart';
import 'home_feed_view.dart';

/// Navigation wrapper hosting the BottomNavigationBar.
/// Manages tab switching, shared favorite items state, mock cart items state, and full French sub-views.
class HomeNavigationWrapper extends StatefulWidget {
  const HomeNavigationWrapper({super.key});

  @override
  State<HomeNavigationWrapper> createState() => _HomeNavigationWrapperState();
}

class _HomeNavigationWrapperState extends State<HomeNavigationWrapper> {
  int _currentIndex = 0;
  final Set<String> _favorites = {};
  final List<String> _cart = ['e1', 'm1']; // Mock items in cart initially

  // Category filter state passed back to Accueil
  String _initialCategoryFilter = 'Tous';

  void _onFavoriteToggle(Product product) {
    setState(() {
      if (_favorites.contains(product.id)) {
        _favorites.remove(product.id);
      } else {
        _favorites.add(product.id);
      }
    });
  }

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
        favorites: _favorites,
        onFavoriteToggle: _onFavoriteToggle,
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
    final List<Product> favoriteProducts =
        mockProducts.where((p) => _favorites.contains(p.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mes Favoris', style: AppTextStyles.headlineLarge),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1.2),
        ),
      ),
      body: favoriteProducts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4B72).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 56,
                        color: Color(0xFFFF4B72),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucun coup de cœur',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vos articles favoris s\'afficheront ici. Commencez à explorer le catalogue !',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => setState(() => _currentIndex = 0),
                        child: Text(
                          'Découvrir des articles',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.51,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ProductCard(
                  product: product,
                  isFavorite: true,
                  onFavoriteToggle: () => _onFavoriteToggle(product),
                );
              },
            ),
    );
  }

  // ── Tab 3: Cart Page ────────────────────────────────────────────────────────
  Widget _buildCartPage() {
    final List<Product> cartProducts =
        mockProducts.where((p) => _cart.contains(p.id)).toList();

    double total = cartProducts.fold(0, (sum, p) => sum + p.price);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mon Panier', style: AppTextStyles.headlineLarge),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1.2),
        ),
      ),
      body: cartProducts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 56,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Votre panier est vide',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Découvrez nos produits et ajoutez-les à votre panier.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => setState(() => _currentIndex = 0),
                        child: Text(
                          'Faire mes achats',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(color: AppColors.surface),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.category,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${product.price.toStringAsFixed(2)} €',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delete Action
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFFFF4B72),
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _cart.remove(product.id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Article retiré du panier'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Checkout Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 1.2),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
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
                              '${total.toStringAsFixed(2)} €',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Commande validée ! (mock)')),
                                );
                              },
                              child: Text(
                                'Passer la commande',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
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
  }

  // ── Tab 4: Profile Page ─────────────────────────────────────────────────────
  Widget _buildProfilePage() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('Mon Profil', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 28),

              // User Info Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          width: 2.5,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sophie Martin',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'sophie.martin@example.com',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Settings Items List
              _buildProfileOption(
                icon: Icons.local_shipping_outlined,
                title: 'Mes Commandes',
                subtitle: 'Historique et suivi des colis',
              ),
              _buildProfileOption(
                icon: Icons.location_on_outlined,
                title: 'Adresses de livraison',
                subtitle: 'Gérer vos adresses de livraison',
              ),
              _buildProfileOption(
                icon: Icons.payment_outlined,
                title: 'Modes de paiement',
                subtitle: 'Gérer vos cartes enregistrées',
              ),
              _buildProfileOption(
                icon: Icons.settings_outlined,
                title: 'Paramètres',
                subtitle: 'Confidentialité, notifications',
              ),
              const SizedBox(height: 36),

              // Log out Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF4B72), width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // Smooth log out transition back to login screen
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
                  child: Text(
                    'Se déconnecter',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFF4B72),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppColors.textHint,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Option: $title (mock)')),
          );
        },
      ),
    );
  }
}
