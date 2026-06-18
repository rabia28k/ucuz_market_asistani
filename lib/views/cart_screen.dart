import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_provider.dart';
import '../models/product_model.dart';
import '../viewmodels/cart_provider.dart';
import 'home_screen.dart'; // 🎯 HomeScreen import edildi

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Akıllı Sepetim', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // 🎯 YENİ: Tek tıkla tüm ara sayfaları silip Ana Menüye ışınlayan Ev Butonu
          IconButton(
            icon: const Icon(Icons.home_rounded, size: 26),
            tooltip: "Ana Menüye Dön",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false, // Arka plandaki tüm eski sayfaları hafızadan temizler
              );
            },
          ),
          // 🎯 DÜZELTİLDİ: Sadece tik atılan alınan ürünleri sepetten süpürür
          IconButton(
            icon: const Icon(Icons.cleaning_services_rounded),
            tooltip: "Seçilenleri Temizle",
            onPressed: () => Provider.of<CartProvider>(context, listen: false).removeBoughtItems(),
          ),
          // 🎯 İSTEĞE BAĞLI PROFESYONEL EKLEME: Tüm sepeti tek seferde tamamen boşaltmak isteyenler için çöp kutusu
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            tooltip: "Tüm Sepeti Boşalt",
            onPressed: () => Provider.of<CartProvider>(context, listen: false).clearCart(),
          )
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_rounded, size: 80, color: Colors.teal.shade100),
                  const SizedBox(height: 16),
                  const Text('Sepetiniz şu an boş.', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
                  const Text('Ürün analiz ekranından ekleme yapabilirsiniz.', style: TextStyle(fontSize: 13, color: Colors.black38)),
                ],
              ),
            );
          }

          Color totalAmountColor;
          if (cartProvider.budgetStatus == 2) {
            totalAmountColor = Colors.red.shade700;
          } else if (cartProvider.budgetStatus == 1) {
            totalAmountColor = Colors.orange.shade700;
          } else {
            totalAmountColor = Colors.teal;
          }

          return Column(
            children: [
              // 🧮 DİNAMİK BÜTÇE AYARLAMA ALANI
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Hedef Alışveriş Bütçeniz (TL)',
                    hintText: 'Örn: 300, 500',
                    prefixIcon: Icon(Icons.account_balance_wallet_rounded,
                        color: cartProvider.budgetStatus == 2 ? Colors.red : (cartProvider.budgetStatus == 1 ? Colors.orange : Colors.teal)
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: cartProvider.budgetStatus == 2 ? Colors.red : (cartProvider.budgetStatus == 1 ? Colors.orange : Colors.teal),
                          width: 2
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    final double? parsedBudget = double.tryParse(value);
                    if (parsedBudget != null && parsedBudget > 0) {
                      cartProvider.updateBudget(parsedBudget);
                    }
                  },
                ),
              ),

              // SEPETTEKİ ÜRÜNLERİN LİSTESİ
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cartItems.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    final item = cartProvider.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              color: item.isBought ? Colors.teal.shade300 : Colors.transparent,
                              width: 1.5
                          )
                      ),
                      color: item.isBought ? Colors.teal.shade50.withOpacity(0.4) : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: IconButton(
                          icon: Icon(
                            item.isBought ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: item.isBought ? Colors.teal : Colors.grey,
                            size: 28,
                          ),
                          onPressed: () => cartProvider.toggleBought(index),
                        ),
                        title: Text(
                          "${item.product.market} - ${item.product.name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: item.isBought ? TextDecoration.lineThrough : null,
                              color: item.isBought ? Colors.grey : Colors.black87
                          ),
                        ),
                        subtitle: Text(
                          "Birim Fiyat: ${item.product.price.toStringAsFixed(2)} TL\nToplam: ${(item.product.price * item.quantity).toStringAsFixed(2)} TL",
                          style: const TextStyle(fontSize: 11, height: 1.3),
                        ),

                        // MİKTAR ARTIRMA / AZALTMA PANELİ
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Eksi (-) Butonu
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(6),
                                icon: Icon(
                                    item.quantity == 1 ? Icons.delete_outline_rounded : Icons.remove_rounded,
                                    color: item.quantity == 1 ? Colors.redAccent : Colors.black54,
                                    size: 20
                                ),
                                onPressed: () => cartProvider.decreaseQuantity(index),
                              ),
                              // Miktar Sayısı
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "${item.quantity}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              // Artı (+) Butonu
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(6),
                                icon: const Icon(Icons.add_rounded, color: Colors.teal, size: 20),
                                onPressed: () => cartProvider.increaseQuantity(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ALT FİYAT VE AKILLI KÂR ÖZET PANELİ
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Elde Edilen Kâr Satırı
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.savings_rounded, color: Colors.green.shade700, size: 20),
                                const SizedBox(width: 8),
                                Text('Elde Edilen Toplam Kâr:', style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Text(
                              '${cartProvider.totalSavedMoney.toStringAsFixed(2)} TL',
                              style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Genel Toplam Satırı
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Genel Toplam Tutar:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                          Text(
                            '${cartProvider.totalCartPrice.toStringAsFixed(2)} TL',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: totalAmountColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}