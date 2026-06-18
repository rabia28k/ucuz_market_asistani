import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../data/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Product> _scannedProducts = [];
  bool _isLoading = false;

  final List<Product> _cartItems = [];

  List<Product> get scannedProducts => _scannedProducts;
  bool get isLoading => _isLoading;

  List<Product> get cartItems => _cartItems;

  int get cartItemsCount => _cartItems.length;

  double get totalCartPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price;
    }
    return total;
  }

  Future<void> searchByBarcode(String barcode) async {
    _isLoading = true;
    notifyListeners();

    try {
      _scannedProducts = await _repository.getProductsByBarcode(barcode);
      _scannedProducts.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
    } catch (e) {
      debugPrint("Hata: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNewProduct(Product product) async {
    await _repository.addProduct(product);
    await searchByBarcode(product.barcode);
  }

  Future<void> removeProduct(int id, String barcode) async {
    await _repository.deleteProduct(id);
    await searchByBarcode(barcode);
  }

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}