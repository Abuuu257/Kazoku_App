import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // Simple in-memory cart
  final Map<String, CartItem> _cart = {};
  Map<String, CartItem> get cart => _cart;

  // Simple auth constants (per user's request)
  static const String kEmail = 'abu@gmail.com';
  static const String kPassword = 'abu123';
  static const String kFullName = 'Abdul rahman';

  void toggleThemeMode() {
    // Cycle: system -> light -> dark -> system
    if (_themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void addToCart(Product p) {
    if (_cart.containsKey(p.id)) {
      _cart[p.id]!.qty += 1;
    } else {
      _cart[p.id] = CartItem(product: p, qty: 1);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void updateQty(String productId, int qty) {
    if (_cart.containsKey(productId)) {
      _cart[productId]!.qty = qty.clamp(1, 99);
      notifyListeners();
    }
  }

  double get cartTotal {
    double sum = 0;
    for (final item in _cart.values) {
      sum += item.total;
    }
    return sum;
  }
}
