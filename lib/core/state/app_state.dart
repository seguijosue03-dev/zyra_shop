import 'package:flutter/material.dart';
import 'package:zyra_shop/features/home/presentation/widgets/mock_products.dart';

class CartItemMock {
  final Product product;
  final String size;
  final Color color;
  int quantity;

  CartItemMock({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });
}

class AppState extends ChangeNotifier {
  // Singleton pattern
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // ── Favorites State ──
  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  bool isFavorite(String productId) => _favorites.contains(productId);

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  // ── Cart State ──
  final List<CartItemMock> _cartItems = [];

  List<CartItemMock> get cartItems => _cartItems;

  void addToCart(Product product, String size, Color color) {
    final index = _cartItems.indexWhere((item) =>
        item.product.id == product.id &&
        item.size == size &&
        item.color == color);

    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(
        CartItemMock(product: product, size: size, color: color, quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  double get cartTotal {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }
}
