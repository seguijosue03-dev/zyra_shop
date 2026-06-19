import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/home/presentation/screens/story_viewer_screen.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/auth/presentation/widgets/zyra_logo_widget.dart';
import 'package:zyra_shop/core/state/app_state.dart';
import '../widgets/mock_products.dart';
import '../widgets/product_card.dart';
import 'package:zyra_shop/features/products/presentation/screens/product_detail_screen.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_dashboard_state.dart';
import 'package:zyra_shop/features/search/presentation/screens/search_screen.dart' as zyra_search;
import 'package:zyra_shop/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:zyra_shop/features/notifications/presentation/state/mock_notifications_state.dart';
import 'package:zyra_shop/features/messaging/presentation/screens/conversations_list_screen.dart';
import 'package:zyra_shop/features/messaging/presentation/state/mock_messaging_state.dart';
import 'package:zyra_shop/shared/widgets/empty_state_widget.dart';

/// Design: 80% white/gray/black neutral, 20% ZYRA brand purple accents.
/// Inspired by Shein, Zara, Amazon, and Instagram Shopping.
class HomeFeedView extends StatefulWidget {
  const HomeFeedView({super.key});

  @override
  State<HomeFeedView> createState() => _HomeFeedViewState();
}

class _HomeFeedViewState extends State<HomeFeedView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategory = 'Tous';
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  // Infinite scroll state
  final List<Product> _feedProducts = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _feedProducts.addAll(mockProducts);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients || _isLoadingMore) return;
    final maxScroll = _scrollCtrl.position.maxScrollExtent;
    final current = _scrollCtrl.position.pixels;
    if (maxScroll - current <= 180.0) _loadMoreProducts();
  }

  Future<void> _loadMoreProducts() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _feedProducts.addAll(mockProducts.map((p) {
        final newId = '${p.id}_load_${DateTime.now().microsecondsSinceEpoch}';
        return Product(
          id: newId,
          name: p.name,
          price: p.price,
          oldPrice: p.oldPrice,
          rating: p.rating,
          ratingCount: p.ratingCount,
          imageUrl: p.imageUrl,
          category: p.category,
          isFeatured: p.isFeatured,
          isTrending: p.isTrending,
          isNewArrival: p.isNewArrival,
        );
      }).toList());
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase().trim();
    List<Product> displayList =
        (query.isEmpty && _selectedCategory == 'Tous')
            ? _feedProducts
            : _feedProducts.where((p) {
                final matchesCat = _selectedCategory == 'Tous' ||
                    p.category == _selectedCategory;
                final matchesSearch = query.isEmpty ||
                    p.name.toLowerCase().contains(query) ||
                    p.category.toLowerCase().contains(query);
                return matchesCat && matchesSearch;
              }).toList();

    final bool isFilteredMode =
        _selectedCategory != 'Tous' || query.isNotEmpty;

    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF8F9FB),
          drawer: _buildDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                // ── Header ─────────────────────────────────
            _buildHeader(context),

            // ── Scrollable Body ─────────────────────────
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollCtrl,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Search
                    _buildSearchBar(),
                    const SizedBox(height: 8),

                    // White card surface for stories + categories
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          if (!isFilteredMode) _buildSellerStories(),
                          if (!isFilteredMode) const SizedBox(height: 8),
                          _buildCategoriesSelector(),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    if (isFilteredMode) ...[
                      const SizedBox(height: 12),
                      _buildFilteredGrid(displayList),
                    ] else if (_feedProducts.isEmpty) ...[
                      const SizedBox(height: 40),
                      const EmptyStateWidget(
                        title: 'Aucun produit disponible',
                        message: 'Revenez plus tard pour découvrir nos nouveautés.',
                        icon: Icons.inventory_2_outlined,
                      ),
                    ] else ...[
                      const SizedBox(height: 16),

                      // Featured Products carousel
                      _buildFeaturedSection(),

                      const SizedBox(height: 20),

                      // Main Feed
                      _buildSectionHeader('Pour vous', null),
                      const SizedBox(height: 12),
                      _buildProductGrid(displayList),

                      const SizedBox(height: 24),

                      // Trending
                      _buildHorizontalProductSection(
                        'Tendances 🔥',
                        'Voir plus',
                        _feedProducts.where((p) => p.isTrending).toList(),
                      ),

                      const SizedBox(height: 24),

                      // New Arrivals
                      _buildHorizontalProductSection(
                        'Nouveautés ✨',
                        'Explorer',
                        _feedProducts.where((p) => p.isNewArrival).toList(),
                      ),
                    ],

                    // Loading spinner
                    if (_isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

  // ─────────────────────────────────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              child: const Icon(
                Icons.menu_rounded,
                color: Color(0xFF111827),
                size: 24,
              ),
            ),
          ),

          // ZYRA Logo — centered typography
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'ZYRA',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF8B3DFF),
                ),
              ),
            ],
          ),

          // Right icons
          Row(
            children: [
              // Chat
              ListenableBuilder(
                listenable: MockMessagingState(),
                builder: (context, _) {
                  final unreadCount = MockMessagingState().globalUnreadCount;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationsListScreen()));
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: Color(0xFF111827),
                            size: 22,
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                              child: Text(
                                unreadCount.toString(),
                                style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              // Bell
              ListenableBuilder(
                listenable: MockNotificationsState(),
                builder: (context, _) {
                  final unreadCount = MockNotificationsState().unreadCount;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF111827),
                            size: 24,
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                              child: Text(
                                unreadCount.toString(),
                                style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),

              // Shopping bag with badge
              ListenableBuilder(
                listenable: AppState(),
                builder: (context, _) {
                  final cartItemCount = AppState().cartItems.length;
                  return GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Panier'),
                          behavior: SnackBarBehavior.floating),
                    ),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            color: Color(0xFF111827),
                            size: 24,
                          ),
                          if (cartItemCount > 0)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF4B72),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  cartItemCount.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DRAWER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Menu', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text('Bienvenue', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildDrawerItem(Icons.home_outlined, 'Accueil', () => Navigator.pop(context)),
                  _buildDrawerItem(Icons.grid_view_outlined, 'Toutes les catégories', () {
                    Navigator.pop(context);
                  }),
                  _buildDrawerItem(Icons.local_offer_outlined, 'Promotions', () {
                    Navigator.pop(context);
                  }),
                  _buildDrawerItem(Icons.storefront_outlined, 'Espace Vendeur', () {
                    Navigator.pop(context);
                  }),
                  _buildDrawerItem(Icons.help_outline, 'Aide & Support', () {
                    Navigator.pop(context);
                  }),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SEARCH BAR
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Main pill input
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const zyra_search.SearchScreen()),
                );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF374151),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Rechercher tendances, marques, styles...',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Filter button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const zyra_search.SearchScreen()),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF374151),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SELLER STORIES
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSellerStories() {
    return ListenableBuilder(
      listenable: MockDashboardState(),
      builder: (context, child) {
        final stories = MockDashboardState().stories;
        if (stories.isEmpty) return const SizedBox.shrink();
        
        return SizedBox(
          height: 108,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              final bool hasGradientRing = story.hasUnread;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryViewerScreen(stories: stories, initialIndex: index))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar with ring
                      CustomPaint(
                        painter: _StoryRingPainter(hasGradient: hasGradientRing),
                        child: Padding(
                          padding: const EdgeInsets.all(3.5),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(story.sellerAvatarUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      // Name
                      SizedBox(
                        width: 68,
                        child: Text(
                          story.sellerName,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CATEGORIES SELECTOR
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCategoriesSelector() {
    if (mockCategories.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: mockCategories.length,
        itemBuilder: (context, index) {
          final category = mockCategories[index];
          final isSelected = _selectedCategory == category.name ||
              (_selectedCategory == 'Tous' && category.name == 'TOUT');

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedCategory =
                    category.name == 'TOUT' ? 'Tous' : category.name;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF111827)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF111827)
                        : const Color(0xFFE5E7EB),
                    width: 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.name,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FEATURED PRODUCTS — Replaces Live Shopping
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFeaturedSection() {
    final featured = _feedProducts.where((p) => p.isFeatured).toList();
    if (featured.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Sélection du moment', 'Voir tout'),
        const SizedBox(height: 12),
        SizedBox(
          height: 108,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              final p = featured[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12, bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          product: p,
                          heroTagPrefix: 'Sélection du moment_',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(14)),
                          child: SizedBox(
                            width: 88,
                            height: 88,
                            child: Image.network(
                              p.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                color: const Color(0xFFF8F9FB),
                                child: const Icon(Icons.image_outlined,
                                    color: Color(0xFF9CA3AF)),
                              ),
                            ),
                          ),
                        ),
                        // Info
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  p.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${p.price.toStringAsFixed(0)} FCFA',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SECTION HEADER (title + optional link)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String? linkLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
          if (linkLabel != null)
            GestureDetector(
              onTap: () {},
              child: Text(
                '$linkLabel →',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HORIZONTAL PRODUCT SECTION (Trending / New Arrivals)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHorizontalProductSection(
      String title, String linkLabel, List<Product> products) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title, linkLabel),
        const SizedBox(height: 12),
        SizedBox(
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ProductCard(
                  product: product,
                  heroTagPrefix: '${title}_',
                  isFavorite: AppState().isFavorite(product.id),
                  onFavoriteToggle: () => AppState().toggleFavorite(product.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          product: product,
                          heroTagPrefix: '${title}_',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MAIN PRODUCT GRID
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildProductGrid(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 12,
          childAspectRatio: 0.51,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            heroTagPrefix: 'Grid_',
            isFavorite: AppState().isFavorite(product.id),
            onFavoriteToggle: () => AppState().toggleFavorite(product.id),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(
                    product: product,
                    heroTagPrefix: 'Grid_',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FILTERED GRID (search / category mode)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFilteredGrid(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${products.length} résultat${products.length > 1 ? 's' : ''}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (products.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded,
                      size: 56, color: Color(0xFF9CA3AF)),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun produit trouvé',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          _buildProductGrid(products),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Painter for story gradient ring
// ─────────────────────────────────────────────────────────────────────────────
class _StoryRingPainter extends CustomPainter {
  final bool hasGradient;
  const _StoryRingPainter({required this.hasGradient});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    if (hasGradient) {
      paint.shader = ui.Gradient.sweep(
        Offset(size.width / 2, size.height / 2),
        const [
          Color(0xFF8B3DFF),
          Color(0xFFC75CFF),
          Color(0xFFFF79A8),
          Color(0xFF8B3DFF),
        ],
        [0.0, 0.33, 0.66, 1.0],
      );
    } else {
      paint.color = const Color(0xFFE5E7EB);
    }

    final radius = (size.width / 2) - paint.strokeWidth / 2;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(covariant _StoryRingPainter old) =>
      old.hasGradient != hasGradient;
}
