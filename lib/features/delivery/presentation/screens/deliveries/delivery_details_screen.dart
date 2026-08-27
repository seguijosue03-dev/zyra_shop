import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/delivery/domain/entities/delivery_order.dart';
import 'package:zyra_shop/features/delivery/presentation/state/mock_delivery_state.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final String deliveryId;
  const DeliveryDetailsScreen({super.key, required this.deliveryId});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  void _advanceStatus(DeliveryOrder order) {
    DeliveryStatus nextStatus;
    if (order.status == DeliveryStatus.prepared) {
      nextStatus = DeliveryStatus.pickedUp;
    } else if (order.status == DeliveryStatus.pickedUp) {
      nextStatus = DeliveryStatus.outForDelivery;
    } else if (order.status == DeliveryStatus.outForDelivery) {
      nextStatus = DeliveryStatus.delivered;
    } else {
      return;
    }

    MockDeliveryState().updateDeliveryStatus(order.id, nextStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Commande #${widget.deliveryId}', style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: MockDeliveryState(),
        builder: (context, _) {
          final orderIndex = MockDeliveryState().deliveries.indexWhere((d) => d.id == widget.deliveryId);
          if (orderIndex == -1) return const Center(child: Text('Commande introuvable'));
          
          final order = MockDeliveryState().deliveries[orderIndex];

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status timeline
                      Container(
                        padding: const EdgeInsets.all(24),
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
                            Text('Suivi de livraison', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 24),
                            _buildTimelineItem(title: 'À récupérer', isCompleted: order.status.index >= DeliveryStatus.prepared.index, isActive: order.status == DeliveryStatus.prepared, isLast: false),
                            _buildTimelineItem(title: 'Colis récupéré', isCompleted: order.status.index >= DeliveryStatus.pickedUp.index, isActive: order.status == DeliveryStatus.pickedUp, isLast: false),
                            _buildTimelineItem(title: 'En livraison', isCompleted: order.status.index >= DeliveryStatus.outForDelivery.index, isActive: order.status == DeliveryStatus.outForDelivery, isLast: false),
                            _buildTimelineItem(title: 'Livré', isCompleted: order.status == DeliveryStatus.delivered, isActive: order.status == DeliveryStatus.delivered, isLast: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Customer info
                      Text('Détails du client', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.person_outline, order.customerName),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.phone_outlined, order.customerPhone, isLink: true),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.location_on_outlined, order.address),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Order Summary
                      Text('Résumé de la commande', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Articles', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                                Text('${order.itemCount}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Montant à encaisser', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                                Text('${order.totalAmount.toInt()} FCFA', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Map placeholder
                      const SizedBox(height: 32),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=Abidjan,CI&zoom=12&size=600x300&maptype=roadmap&key=mock_key'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.map, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text("Voir l'itinéraire", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
              
              // Bottom Action Button
              if (order.status != DeliveryStatus.delivered)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => _advanceStatus(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          _getActionText(order.status),
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _getActionText(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.prepared:
        return 'Récupérer le colis';
      case DeliveryStatus.pickedUp:
        return 'Commencer la livraison';
      case DeliveryStatus.outForDelivery:
        return 'Marquer comme livré';
      case DeliveryStatus.delivered:
        return 'Livré';
    }
  }

  Widget _buildTimelineItem({required String title, required bool isCompleted, bool isActive = false, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : (isActive ? AppColors.primary : Colors.grey.shade300),
                shape: BoxShape.circle,
              ),
              child: isCompleted 
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : (isActive ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))) : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isCompleted || isActive ? AppColors.textPrimary : Colors.grey.shade500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isLink = false}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isLink ? Colors.blue : AppColors.textPrimary,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

