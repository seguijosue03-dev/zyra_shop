import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'home_feed_view.dart';
import 'package:zyra_shop/features/profile/presentation/screens/profile_screen.dart';
import 'package:zyra_shop/features/categories/presentation/screens/categories_screen.dart';
import 'package:zyra_shop/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:zyra_shop/features/cart/presentation/screens/cart_screen.dart';

/// Manages tab switching and bottom navigation for the main app shell.
class HomeNavigationWrapper extends StatefulWidget {
  const HomeNavigationWrapper({super.key});

  @override
  State<HomeNavigationWrapper> createState() => _HomeNavigationWrapperState();
}

class _HomeNavigationWrapperState extends State<HomeNavigationWrapper> {
  int _currentIndex = 0;
  String _initialCategoryFilter = 'Tous';

  void _goToHomeWithCategory(String category) {
    setState(() {
      _initialCategoryFilter = category;
      _currentIndex = 0;
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
      CategoriesScreen(onCategorySelected: _goToHomeWithCategory),

      // 2. Favorites Grid (Favoris)
      WishlistScreen(
        onNavigateToCart: () => setState(() => _currentIndex = 3),
        onNavigateToHome: () => setState(() => _currentIndex = 0),
      ),

      // 3. Cart View (Panier)
      CartScreen(
        onNavigateToHome: () => setState(() => _currentIndex = 0),
        onNavigateToFavorites: () => setState(() => _currentIndex = 2),
      ),

      // 4. Profile Dashboard (Profil)
      ProfileScreen(
        onNavigateHome: () => setState(() => _currentIndex = 0),
        onNavigateFavorites: () => setState(() => _currentIndex = 2),
      ),
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
            const SizedBox(
              height: 68,
              width: double.infinity,
            ),
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
}
