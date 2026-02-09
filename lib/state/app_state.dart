import 'dart:io';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  final Map<String, CartItem> _cart = {};
  Map<String, CartItem> get cart => _cart;

  final List<Order> _orders = [];
  List<Order> get orders => _orders;

  final ApiService _apiService = ApiService();
  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void toggleThemeMode() {
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

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _apiService.login(email, password);
      _user = User.fromJson(res['user']);
      _apiService.setToken(res['token']);
      await fetchProducts();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String name, String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _apiService.register(name, username, email, password);
      // Auto login
      _user = User.fromJson(res['user']);
      _apiService.setToken(res['token']);
      await fetchProducts();
    } catch (e) {
       _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    _cart.clear(); // Clear cart on logout
    _orders.clear(); // Clear orders on logout
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    try {
      _products = await _apiService.getProducts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
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

  Future<void> checkout() async {
    if (_cart.isEmpty) return;
    
    // Simulate order processing delay
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    // Create new order
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: _cart.values.toList(),
      total: cartTotal,
    );

    // Add to history
    _orders.insert(0, newOrder);

    // Clear cart
    _cart.clear();
    _isLoading = false;
    notifyListeners();
  }

  // Method to update user profile with backend persistence
  Future<void> updateUserProfile({
    required String name,
    required String username,
    required String email,
    File? profileImageLocal,
  }) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Call the API with the image path
      final response = await _apiService.updateProfile(
        name: name,
        username: username,
        email: email,
        imagePath: profileImageLocal?.path,
      );

      // Update the user from the response
      _user = User.fromJson(response['user']);
      
      // If there's a local image, keep it for immediate display
      if (profileImageLocal != null) {
        _user = _user!.copyWith(profileImageLocal: profileImageLocal);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
