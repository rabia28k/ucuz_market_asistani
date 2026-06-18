import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isBought; // Market arabasına atıldı mı (İşaretleme için)
  final double savedMoney; // Bu üründen elde edilen kâr miktarı

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isBought = false,
    required this.savedMoney,
  });
}