import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Product selectedProduct, List<Product> allOptionsForThisBarcode) {
    double profit = 0.0;
    if (allOptionsForThisBarcode.length > 1) {
      double maxPrice = allOptionsForThisBarcode
          .map((p) => p.price)
          .reduce((curr, next) => curr > next ? curr : next);
      profit = maxPrice - selectedProduct.price;
    }

    int index = _cartItems.indexWhere((item) => item.product.id == selectedProduct.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: selectedProduct, savedMoney: profit > 0 ? profit : 0.0));
    }
    notifyListeners();
  }

  void toggleBought(int index) {
    _cartItems[index].isBought = !_cartItems[index].isBought;
    notifyListeners();
  }

  void removeBoughtItems() {
    _cartItems.removeWhere((item) => item.isBought);
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  double get totalCartPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double get totalSavedMoney {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.savedMoney * item.quantity));
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double _budgetLimit = 500.0;

  double get budgetLimit => _budgetLimit;

  void updateBudget(double newLimit) {
    _budgetLimit = newLimit;
    notifyListeners();
  }

  int get budgetStatus {
    if (totalCartPrice > _budgetLimit) {
      return 2;
    } else if (totalCartPrice >= _budgetLimit * 0.8) {
      return 1;
    }
    return 0;
  }

  void increaseQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }
}