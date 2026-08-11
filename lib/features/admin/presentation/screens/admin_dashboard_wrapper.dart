import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_overview_screen.dart';
import 'admin_sellers_screen.dart';
import 'admin_products_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_settings_screen.dart';
import 'package:zyra_shop/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:zyra_shop/features/notifications/presentation/state/mock_notifications_state.dart';
import 'package:zyra_shop/features/messaging/presentation/screens/conversations_list_screen.dart';
import 'package:zyra_shop/features/messaging/presentation/state/mock_messaging_state.dart';

class AdminDashboardWrapper extends StatefulWidget {
  const AdminDashboardWrapper({super.key});

  @override
  State<AdminDashboardWrapper> createState() => _AdminDashboardWrapperState();
}

class _AdminDashboardWrapperState extends State<AdminDashboardWrapper> {
  int _selectedIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  final List<Widget> _pages = const [
    AdminOverviewScreen(),
    AdminSellersScreen(),
    AdminProductsScreen(),
    AdminOrdersScreen(),
    AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: !isDesktop ? Drawer(
        backgroundColor: Colors.white,
        child: _buildSidebarContent(context),
      ) : null,
      body: Row(
        children: [
          // Premium Sidebar (Visible only on Desktop)
          if (isDesktop)
            Container(
              width: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Colors.black.withOpacity(0.05), width: 1)),
              ),
              child: _buildSidebarContent(context),
            ),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.05), width: 1)),
                  ),
                  child: Row(
                    children: [
                      if (!isDesktop)
                        Builder(
                          builder: (context) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: IconButton(
                              icon: const Icon(Icons.menu, color: Colors.black87),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                        ),
                      // Search Bar Functional
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black.withOpacity(0.05)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, size: 16, color: Colors.black54),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    focusNode: _searchFocusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Rechercher...',
                                      hintStyle: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: GoogleFonts.inter(fontSize: 13, color: Colors.black87),
                                    onSubmitted: (value) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Recherche (Admin) pour : $value')),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _searchFocusNode.requestFocus();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: Text('⌘ K', style: GoogleFonts.inter(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ListenableBuilder(
                        listenable: MockMessagingState(),
                        builder: (context, _) {
                          final unreadCount = MockMessagingState().globalUnreadCount;
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.04),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87, size: 20),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationsListScreen()));
                                  },
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                                    child: Text(
                                      unreadCount.toString(),
                                      style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      ListenableBuilder(
                        listenable: MockNotificationsState(),
                        builder: (context, _) {
                          final unreadCount = MockNotificationsState().unreadCount;
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.04),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.notifications_none, color: Colors.black87, size: 22),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                                  },
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                                    child: Text(
                                      unreadCount.toString(),
                                      style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE91E63), Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Text('A', style: GoogleFonts.inter(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                'ZYRA Admin',
                style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: -0.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        _buildNavItem(context, 0, Icons.insert_chart_outlined, 'Vue d\'ensemble'),
        _buildNavItem(context, 1, Icons.people_outline, 'Vendeurs'),
        _buildNavItem(context, 2, Icons.inventory_2_outlined, 'Produits'),
        _buildNavItem(context, 3, Icons.shopping_bag_outlined, 'Commandes'),
        const Spacer(),
        _buildNavItem(context, 4, Icons.settings_outlined, 'Paramètres'),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String title) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (!isDesktop) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE91E63).withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isSelected ? const Color(0xFFE91E63) : Colors.grey.shade600),
            const SizedBox(width: 14),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFFE91E63) : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
