import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/delivery/domain/entities/delivery_order.dart';
import 'package:zyra_shop/features/delivery/presentation/state/mock_delivery_state.dart';
import 'package:zyra_shop/features/delivery/presentation/screens/deliveries/delivery_details_screen.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockDeliveryState(),
      builder: (context, _) {
        final state = MockDeliveryState();
        final name = state.registrationData?['firstName'] ?? 'Livreur';
        final zone = state.registrationData?['zone'] ?? 'Cocody';

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bonjour, $name 👋', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(zone, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => state.toggleOnlineStatus(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: state.isOnline ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: state.isOnline ? Colors.green.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.5)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: state.isOnline ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                state.isOnline ? 'Disponible' : 'Hors ligne',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: state.isOnline ? Colors.green : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // KPIs
                  Row(
                    children: [
                      Expanded(
                        child: _buildKpiCard(
                          title: 'À récupérer',
                          value: state.pendingCount.toString(),
                          icon: Icons.inventory_2_rounded,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildKpiCard(
                          title: 'En livraison',
                          value: state.inProgressCount.toString(),
                          icon: Icons.local_shipping_rounded,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildKpiCard(
                    title: "Livrés aujourd'hui",
                    value: state.deliveredCount.toString(),
                    icon: Icons.check_circle_rounded,
                    color: Colors.green,
                    isWide: true,
                  ),

                  const SizedBox(height: 40),
                  Text('Mes livraisons', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 16),

                  if (state.deliveriesToday.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text("Vous n'avez actuellement aucune livraison.", style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                    )
                  else
                    ...state.deliveriesToday.map((d) => _buildDeliveryCard(d)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKpiCard({required String title, required String value, required IconData icon, required Color color, bool isWide = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isWide 
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(value, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.1)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 18),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 16),
                Text(value, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.1)),
                const SizedBox(height: 4),
                Text(title, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
    );
  }

  Widget _buildDeliveryCard(DeliveryOrder order) {
    Color statusColor;
    String statusText;

    switch (order.status) {
      case DeliveryStatus.prepared:
        statusColor = Colors.orange;
        statusText = 'À récupérer';
        break;
      case DeliveryStatus.pickedUp:
        statusColor = Colors.blue;
        statusText = 'Colis récupéré';
        break;
      case DeliveryStatus.outForDelivery:
        statusColor = Colors.purple;
        statusText = 'En livraison';
        break;
      case DeliveryStatus.delivered:
        statusColor = Colors.green;
        statusText = 'Livré';
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryDetailsScreen(deliveryId: order.id)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${order.id}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(statusText, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(order.customerName, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(order.zone, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${order.itemCount} articles', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                Text('${order.totalAmount.toInt()} FCFA', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
