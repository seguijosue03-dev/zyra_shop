import 'package:flutter/material.dart';
import 'package:zyra_shop/features/seller/domain/entities/seller_story.dart';

class MockDashboardState extends ChangeNotifier {
  static final MockDashboardState _instance = MockDashboardState._internal();
  factory MockDashboardState() => _instance;
  MockDashboardState._internal();

  // PRODUCTS
  List<Map<String, dynamic>> products = [];

  void addProduct(Map<String, dynamic> product) {
    products.insert(0, product);
    notifyListeners();
  }

  void updateProduct(String id, Map<String, dynamic> newProduct) {
    final index = products.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      products[index] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p['id'] == id);
    notifyListeners();
  }

  // ORDERS
  List<Map<String, dynamic>> orders = [];

  void updateOrderStatus(String id, String newStatus, Color color) {
    final index = orders.indexWhere((o) => o['id'] == id);
    if (index != -1) {
      orders[index]['status'] = newStatus;
      orders[index]['statusColor'] = color;
      notifyListeners();
    }
  }

  // STORIES
  List<SellerStory> stories = [];

  void addStory(SellerStory story) {
    stories.insert(0, story);
    notifyListeners();
  }
}
