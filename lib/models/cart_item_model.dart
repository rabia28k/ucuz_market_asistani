import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isBought;
  final double savedMoney;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isBought = false,
    required this.savedMoney,
  });
}