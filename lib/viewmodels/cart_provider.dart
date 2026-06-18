import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Sepete Ürün Ekleme ve Akıllı Kâr Hesaplama
  void addToCart(Product selectedProduct, List<Product> allOptionsForThisBarcode) {
    // Eğer bu barkoda ait başka pahalı seçenekler varsa aradaki farktan kârı buluyoruz
    double profit = 0.0;
    if (allOptionsForThisBarcode.length > 1) {
      // En pahalı seçeneğin toplam fiyatı
      double maxPrice = allOptionsForThisBarcode
          .map((p) => p.price)
          .reduce((curr, next) => curr > next ? curr : next);
      profit = maxPrice - selectedProduct.price;
    }

    // Sepette zaten var mı kontrolü
    int index = _cartItems.indexWhere((item) => item.product.id == selectedProduct.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: selectedProduct, savedMoney: profit > 0 ? profit : 0.0));
    }
    notifyListeners();
  }

  // Ürün Alındı / Alınmadı İşaretlemesi (Check sistemi)
  void toggleBought(int index) {
    _cartItems[index].isBought = !_cartItems[index].isBought;
    notifyListeners();
  }

  // 🎯 YENİ: Sadece solundaki tik işareti seçilmiş (isBought = true) olan ürünleri sepetten siler
  void removeBoughtItems() {
    _cartItems.removeWhere((item) => item.isBought);
    notifyListeners();
  }

  // Sepetten Ürün Silme
  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // Genel Toplam Tutar Hesaplama
  double get totalCartPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Toplam Elde Edilen Kâr Hesaplama
  double get totalSavedMoney {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.savedMoney * item.quantity));
  }

  // Sepeti Sıfırlama
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
  // Varsayılan bütçe sınırı (Kullanıcı değiştirebilir)
  double _budgetLimit = 500.0;

  double get budgetLimit => _budgetLimit;

  // Bütçeyi güncelleme fonksiyonu
  void updateBudget(double newLimit) {
    _budgetLimit = newLimit;
    notifyListeners();
  }

  // Bütçe Durum Kontrolü (Renk belirlemek için)
  // 0 -> Güvenli (Yeşil/Teal)
  // 1 -> Kritik Sınır %80'i aştı (Sarı/Turuncu)
  // 2 -> Bütçe Tamamen Aşıldı (Kırmızı)
  int get budgetStatus {
    if (totalCartPrice > _budgetLimit) {
      return 2; // Bütçe aşıldı!
    } else if (totalCartPrice >= _budgetLimit * 0.8) {
      return 1; // %80 kritik sınır!
    }
    return 0; // Güvenli bölge
  }
  // Ürün Miktarını Artırma (+)
  void increaseQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  // Ürün Miktarını Azaltma (-)
  void decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    } else {
      // Eğer miktar 1 iken eksiye basılırsa ürünü sepetten tamamen siler
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }
}