import 'package:flutter/material.dart';
import 'package:zyra_shop/features/home/presentation/widgets/mock_products.dart';

enum OrderStatus {
  confirmed,
  preparing,
  shipped,
  delivering,
  delivered,
  cancelled
}

class OrderItemMock {
  final Product product;
  final String size;
  final Color color;
  final int quantity;
  final double priceAtPurchase;

  OrderItemMock({
    required this.product,
    required this.size,
    required this.color,
    required this.quantity,
    required this.priceAtPurchase,
  });
}

class OrderMock {
  final String id;
  final DateTime date;
  final OrderStatus status;
  final String paymentMethod;
  final String deliveryAddress;
  final List<OrderItemMock> items;
  final double shippingFee;

  OrderMock({
    required this.id,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.items,
    this.shippingFee = 2000.0,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + (item.priceAtPurchase * item.quantity));
  double get total => subtotal + shippingFee;
}

final List<OrderMock> mockOrders = [];
