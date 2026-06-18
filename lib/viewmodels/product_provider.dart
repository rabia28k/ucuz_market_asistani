import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../data/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Product> _scannedProducts = [];
  bool _isLoading = false;

  // 🔥 YENİ: Canlı sepet verilerini tutacak liste
  final List<Product> _cartItems = [];

  List<Product> get scannedProducts => _scannedProducts;
  bool get isLoading => _isLoading;

  // 🔥 YENİ: Dışarıdan sepet elemanlarına erişim sağlayan getter
  List<Product> get cartItems => _cartItems;

  // 🔥 YENİ: Sepetteki benzersiz veya toplam ürün sayısını döner
  int get cartItemsCount => _cartItems.length;

  // 🔥 YENİ: Sepetteki ürünlerin fiyatlarını anlık toplayan fonksiyon
  double get totalCartPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price;
    }
    return total;
  }

  // Barkod okutulduğunda çalışan ana fonksiyon
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

  // Yeni ürün ekleme fonksiyonu (Veritabanı)
  Future<void> addNewProduct(Product product) async {
    await _repository.addProduct(product);
    await searchByBarcode(product.barcode);
  }

  // Ürün silme fonksiyonu (Veritabanı)
  Future<void> removeProduct(int id, String barcode) async {
    await _repository.deleteProduct(id);
    await searchByBarcode(barcode);
  }

  // =======================================================
  // 🔥 YENİ: SEPET YÖNETİM METOTLARI (Arayüzü tetikler)
  // =======================================================

  // Sepete ürün ekle ve dinleyen widget'ları uyar
  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  // Sepetten ürün çıkar ve dinleyen widget'ları uyar
  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  // Sepeti komple boşalt
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}