import 'package:flutter/material.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import '../../domain/entities/order_mock.dart';
import '../widgets/order_timeline_step.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderMock order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    int currentStepIndex = _getStepIndex(order.status);
    final isCancelled = order.status == OrderStatus.cancelled;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Suivi de commande', style: AppTextStyles.headlineLarge.copyWith(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isCancelled
              ? _buildCancelledState()
              : Column(
                  children: [
                    OrderTimelineStep(
                      title: 'Commande confirmée',
                      subtitle: 'Votre commande a été enregistrée avec succès.',
                      isCompleted: currentStepIndex > 0,
                      isActive: currentStepIndex == 0,
                      icon: Icons.receipt_long_rounded,
                    ),
                    OrderTimelineStep(
                      title: 'Préparation',
                      subtitle: 'Le vendeur prépare votre colis.',
                      isCompleted: currentStepIndex > 1,
                      isActive: currentStepIndex == 1,
                      icon: Icons.inventory_2_rounded,
                    ),
                    OrderTimelineStep(
                      title: 'Expédiée',
                      subtitle: 'Le colis a été remis au transporteur.',
                      isCompleted: currentStepIndex > 2,
                      isActive: currentStepIndex == 2,
                      icon: Icons.local_shipping_rounded,
                    ),
                    OrderTimelineStep(
                      title: 'En cours de livraison',
                      subtitle: 'Le livreur est en route vers votre adresse.',
                      isCompleted: currentStepIndex > 3,
                      isActive: currentStepIndex == 3,
                      icon: Icons.map_rounded,
                    ),
                    OrderTimelineStep(
                      title: 'Livrée',
                      subtitle: 'Le colis a été livré avec succès.',
                      isCompleted: currentStepIndex > 4,
                      isActive: currentStepIndex == 4,
                      isLast: true,
                      icon: Icons.home_rounded,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  int _getStepIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivering:
        return 3;
      case OrderStatus.delivered:
        return 4;
      default:
        return -1;
    }
  }

  Widget _buildCancelledState() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFC62828), width: 2),
          ),
          child: const Icon(Icons.close_rounded, color: Color(0xFFC62828), size: 32),
        ),
        const SizedBox(height: 24),
        const Text(
          'Commande annulée',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC62828),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Cette commande a été annulée et ne sera pas livrée.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
