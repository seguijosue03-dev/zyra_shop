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

  void addToCart(Product product, String size, Color color, int quantity) {
    final index = _cartItems.indexWhere((item) =>
        item.product.id == product.id &&
        item.size == size &&
        item.color == color);

    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(
        CartItemMock(product: product, size: size, color: color, quantity: quantity),
      );
    }
    notifyListeners();
  }

  void updateCartQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length && newQuantity >= 1) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void updateCartSize(int index, String newSize) {
    if (index >= 0 && index < _cartItems.length) {
      final item = _cartItems[index];
      _cartItems[index] = CartItemMock(
        product: item.product,
        size: newSize,
        color: item.color,
        quantity: item.quantity,
      );
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void removeItemsFromCart(List<int> indicesToRemove) {
    final sortedIndices = List<int>.from(indicesToRemove)..sort((a, b) => b.compareTo(a));
    for (var i in sortedIndices) {
      if (i >= 0 && i < _cartItems.length) {
        _cartItems.removeAt(i);
      }
    }
    notifyListeners();
  }

  void addItemsToFavorites(List<String> productIds) {
    bool changed = false;
    for (var id in productIds) {
      if (!_favorites.contains(id)) {
        _favorites.add(id);
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get cartTotal {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  // ── Direct Checkout State ──
  List<CartItemMock>? _directCheckoutItems;

  List<CartItemMock> get activeCheckoutItems => _directCheckoutItems ?? _cartItems;

  double get activeCheckoutTotal {
    return activeCheckoutItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  void startDirectCheckout(Product product, String size, Color color, int quantity) {
    _directCheckoutItems = [
      CartItemMock(product: product, size: size, color: color, quantity: quantity)
    ];
    notifyListeners();
  }

  void clearDirectCheckout() {
    _directCheckoutItems = null;
    notifyListeners();
  }

  // ── Address State ──
  String? shippingAddressName;
  String? shippingAddressLocation;

  void saveShippingAddress(String name, String location) {
    shippingAddressName = name;
    shippingAddressLocation = location;
    notifyListeners();
  }

  void clearActiveCheckout() {
    if (_directCheckoutItems != null) {
      _directCheckoutItems = null;
    } else {
      _cartItems.clear();
    }
    notifyListeners();
  }
}
