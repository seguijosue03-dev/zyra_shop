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

final List<OrderMock> mockOrders = [
  OrderMock(
    id: 'ZY-10492',
    date: DateTime.now().subtract(const Duration(days: 1)),
    status: OrderStatus.shipped,
    paymentMethod: 'Wave',
    deliveryAddress: 'Cocody Riviera 2, Abidjan',
    items: [
      OrderItemMock(
        product: mockProducts[0], // Assuming mockProducts[0] is clothing
        size: 'M',
        color: Colors.black,
        quantity: 1,
        priceAtPurchase: mockProducts[0].price,
      ),
    ],
  ),
  OrderMock(
    id: 'ZY-10385',
    date: DateTime.now().subtract(const Duration(days: 3)),
    status: OrderStatus.delivered,
    paymentMethod: 'Orange Money',
    deliveryAddress: 'Marcory Zone 4, Abidjan',
    items: [
      OrderItemMock(
        product: mockProducts[2],
        size: 'L',
        color: const Color(0xFFE8DCC4),
        quantity: 2,
        priceAtPurchase: mockProducts[2].price,
      ),
      OrderItemMock(
        product: mockProducts[3],
        size: 'M',
        color: Colors.white,
        quantity: 1,
        priceAtPurchase: mockProducts[3].price,
      ),
    ],
  ),
  OrderMock(
    id: 'ZY-10210',
    date: DateTime.now().subtract(const Duration(days: 15)),
    status: OrderStatus.cancelled,
    paymentMethod: 'Carte Bancaire',
    deliveryAddress: 'Cocody Angré, Abidjan',
    items: [
      OrderItemMock(
        product: mockProducts[1],
        size: 'S',
        color: Colors.blue,
        quantity: 1,
        priceAtPurchase: mockProducts[1].price,
      ),
    ],
  ),
];
