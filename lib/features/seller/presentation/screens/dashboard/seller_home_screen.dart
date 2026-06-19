import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_dashboard_state.dart';
import 'package:zyra_shop/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:zyra_shop/features/notifications/presentation/state/mock_notifications_state.dart';
import 'package:zyra_shop/features/messaging/presentation/screens/conversations_list_screen.dart';
import 'package:zyra_shop/features/messaging/presentation/state/mock_messaging_state.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_shadows.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bonjour, ZYRA Seller', style: GoogleFonts.inter(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Aperçu de votre activité', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
          ],
        ),
        actions: [
          ListenableBuilder(
            listenable: MockMessagingState(),
            builder: (context, _) {
              final unreadCount = MockMessagingState().globalUnreadCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationsListScreen()));
                    },
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
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                    },
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
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: MockDashboardState(),
        builder: (context, _) {
          final state = MockDashboardState();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI Grid
                Row(
                  children: [
                    Expanded(child: _buildKpiCard('Revenus', '0 FCFA', '0%', true)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildKpiCard('Commandes', state.orders.length.toString(), '+5%', false)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildKpiCard('Produits', state.products.length.toString(), null, false)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildKpiCard('Stories', state.stories.length.toString(), null, false)),
                  ],
                ),
                const SizedBox(height: 32),

            // Revenue Chart Area
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Revenus', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                PopupMenuButton<String>(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Text('Ce mois', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Ce mois', child: Text('Ce mois')),
                    const PopupMenuItem(value: 'Mois dernier', child: Text('Mois dernier')),
                    const PopupMenuItem(value: 'Cette année', child: Text('Cette année')),
                  ],
                  onSelected: (val) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Période sélectionnée: $val')));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Mock Chart container
            Container(
              width: double.infinity,
              height: 240,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.premiumCard,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Total', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600)),
                      const SizedBox(width: 8),
                      Text('0 FCFA', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  const Spacer(),
                  // Very simple mock chart visualization using containers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChartBar(0.0, 'Lun'),
                      _buildChartBar(0.0, 'Mar'),
                      _buildChartBar(0.0, 'Mer'),
                      _buildChartBar(0.0, 'Jeu'),
                      _buildChartBar(0.0, 'Ven'),
                      _buildChartBar(0.0, 'Sam', isHighlight: true),
                      _buildChartBar(0.0, 'Dim'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('Dernières commandes', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            if (state.orders.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text('Aucune commande', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              )
            else
              ...state.orders.take(3).map((o) => _buildRecentOrderMock(o['id'], o['status'], o['statusColor'])).toList(),
            const SizedBox(height: 48),
          ],
        ),
      );
      }),
    );
  }

  Widget _buildKpiCard(String title, String value, String? trend, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.textPrimary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary ? null : Border.all(color: AppColors.border),
        boxShadow: AppShadows.premiumCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 13, color: isPrimary ? Colors.white70 : Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: isPrimary ? Colors.white : Colors.black87)),
          if (trend != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.trending_up_rounded, color: isPrimary ? Colors.greenAccent : Colors.green, size: 14),
                const SizedBox(width: 4),
                Text(trend, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isPrimary ? Colors.greenAccent : Colors.green)),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildChartBar(double heightFactor, String label, {bool isHighlight = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: 120 * heightFactor,
          decoration: BoxDecoration(
            color: isHighlight ? const Color(0xFFFF4B72) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildRecentOrderMock(String id, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.premiumCard,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.black54, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('Aujourd\'hui', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ],
      ),
    );
  }
}
