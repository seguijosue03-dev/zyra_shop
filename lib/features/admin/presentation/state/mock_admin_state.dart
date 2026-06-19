import 'package:flutter/material.dart';

class MockAdminState extends ChangeNotifier {
  static final MockAdminState _instance = MockAdminState._internal();
  factory MockAdminState() => _instance;
  MockAdminState._internal();

  // SELLERS
  List<Map<String, dynamic>> sellers = [];

  void updateSellerStatus(String id, String status) {
    final index = sellers.indexWhere((s) => s['id'] == id);
    if (index != -1) {
      sellers[index]['status'] = status;
      notifyListeners();
    }
  }

  // PRODUCTS
  List<Map<String, dynamic>> products = [];

  void updateProductStatus(String id, String status) {
    final index = products.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      products[index]['status'] = status;
      notifyListeners();
    }
  }
}
