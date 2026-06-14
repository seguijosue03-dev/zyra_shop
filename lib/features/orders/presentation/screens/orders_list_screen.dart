import 'package:flutter/material.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import '../../domain/entities/order_mock.dart';
import '../widgets/order_card.dart';
import '../widgets/empty_orders_state.dart';
import 'order_details_screen.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mes commandes', style: AppTextStyles.headlineLarge.copyWith(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: mockOrders.isEmpty
          ? const EmptyOrdersState()
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              itemCount: mockOrders.length,
              itemBuilder: (context, index) {
                final order = mockOrders[index];
                return OrderCard(
                  order: order,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
