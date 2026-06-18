import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_provider.dart';
import '../models/product_model.dart';
import 'add_product_screen.dart';
import '../viewmodels/cart_provider.dart';
import 'cart_screen.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final String barcode;
  const ResultScreen({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Yapay Zeka Analiz Sonuçları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, size: 26),
            tooltip: "Ana Menüye Dön",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator(color: Colors.teal));
          if (provider.scannedProducts.isEmpty) return _buildEmptyState(context);

          final bestPriceProduct = provider.scannedProducts[0];

          Product? healthyAlternative;
          for (var p in provider.scannedProducts) {
            if (p.id != bestPriceProduct.id && p.healthScore >= 8) {
              healthyAlternative = p;
              break;
            }
          }

          return Column(
            children: [
              // ÜST ÖNERİ PANELLERİ (Kaydırılabilir Akıllı Kartlar)
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))
                    ]
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  child: Row(
                    children: [
                      _buildAnalysisBox(
                        title: "EN EKONOMİK SEÇENEK",
                        icon: Icons.auto_awesome_rounded,
                        boxColor: Colors.amber.shade50,
                        borderColor: Colors.amber.shade300,
                        iconColor: Colors.orange.shade800,
                        textColor: Colors.amber.shade900,
                        text: "Şu an en avantajlısı ${bestPriceProduct.market} marketindeki ${bestPriceProduct.name} ürünüdür!",
                        subText: "Birim Fiyatı: ${bestPriceProduct.unitPrice.toStringAsFixed(2)} TL",
                      ),
                      if (healthyAlternative != null) ...[
                        const SizedBox(width: 12),
                        _buildAnalysisBox(
                          title: "SAĞLIKLI YAŞAM SEÇENEĞİ",
                          icon: Icons.health_and_safety_rounded,
                          boxColor: Colors.green.shade50,
                          borderColor: Colors.green.shade200,
                          iconColor: Colors.green.shade700,
                          textColor: Colors.green.shade900,
                          text: "Bütçeniz elveriyorsa, ${healthyAlternative.market} marketindeki temiz içerikli ${healthyAlternative.name} ürününü öneririz.",
                          subText: "Sağlık Skoru: ${healthyAlternative.healthScore}/10 (${healthyAlternative.ingredientsNote})",
                        ),
                      ]
                    ],
                  ),
                ),
              ),

              // TÜM SEÇENEKLERİN LİSTELENMESİ
              Expanded(
                child: ListView.builder(
                  itemCount: provider.scannedProducts.length,
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
                  itemBuilder: (context, index) {
                    final product = provider.scannedProducts[index];
                    final isCheapest = index == 0;
                    return _buildProductCard(context, product, isCheapest);
                  },
                ),
              ),
              _buildAddMoreButton(context),
            ],
          );
        },
      ),

      // BÜTÇE KONTROLLÜ AKILLI ALT SEPET BARI
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) return const SizedBox.shrink();

          List<Color> barColors;
          IconData barIcon;
          String alertText = "${cartProvider.cartItems.length} Farklı Ürün Eklendi";

          if (cartProvider.budgetStatus == 2) {
            barColors = [Colors.red.shade700, Colors.redAccent];
            barIcon = Icons.gpp_bad_rounded;
            alertText = "⚠️ Bütçe Sınırı Aşıldı!";
          } else if (cartProvider.budgetStatus == 1) {
            barColors = [Colors.orange.shade600, Colors.amber.shade700];
            barIcon = Icons.warning_amber_rounded;
            alertText = "⚠️ Limit Sınırına Yaklaştınız (%80+)";
          } else {
            barColors = [Colors.teal, Colors.green.shade600];
            barIcon = Icons.shopping_bag_outlined;
          }

          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: barColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: barColors[0].withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(barIcon, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alertText, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          "${cartProvider.totalCartPrice.toStringAsFixed(2)} TL / ${cartProvider.budgetLimit.toStringAsFixed(0)} TL",
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                  },
                  icon: const Text("Sepetime Git", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  label: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 12),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.18),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalysisBox({
    required String title,
    required IconData icon,
    required Color boxColor,
    required Color borderColor,
    required Color iconColor,
    required Color textColor,
    required String text,
    required String subText,
  }) {
    return Container(
      width: 310,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(color: iconColor.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 3))
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: iconColor, fontSize: 11, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87, height: 1.3)),
          const SizedBox(height: 8),
          Text(subText, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, bool isCheapest) {
    final bool isSystemProduct = product.id != null && product.id! <= 50;
    String unitLabel = product.unit.toLowerCase() == "adet" ? "1 Adet" : "1 ${product.unit}";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isCheapest ? Colors.green.shade400 : Colors.grey.shade200, width: isCheapest ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: isCheapest ? Colors.green.withOpacity(0.06) : Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          if (isCheapest)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: const Text(
                  "EN AVANTAJLI",
                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              // 🎯 TAHMİN EDİLEN YAZIM HATASI BU SATIRDA TAMİR EDİLDİ
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: product.healthScore >= 8 ? Colors.green.shade50 : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${product.healthScore}",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: product.healthScore >= 8 ? Colors.green.shade700 : Colors.black54
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product.market} - ${product.name}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Net Paket: ${product.amount} ${product.unit} | Kıyaslama ($unitLabel): ${product.unitPrice.toStringAsFixed(2)} TL",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                      ),
                      if (product.amount < 1 && product.unit.toLowerCase() != "adet") ...[
                        const SizedBox(height: 4),
                        Text(
                          "💡 Paket 1 ${product.unit}'dan az olduğu için paket fiyatı düşüktür.",
                          style: TextStyle(fontSize: 10, color: Colors.blue.shade600, fontWeight: FontWeight.w500),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        "İçerik: ${product.ingredientsNote}",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${product.price.toStringAsFixed(2)} TL",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: isCheapest ? Colors.green.shade700 : Colors.black87,
                          fontSize: 16
                      ),
                    ),
                    const Text("Paket Fiyatı", style: TextStyle(fontSize: 9, color: Colors.black38, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false).addToCart(
                                product,
                                Provider.of<ProductProvider>(context, listen: false).scannedProducts
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.market} - ${product.name} Sepete Eklendi! 🛒'),
                                backgroundColor: isCheapest ? Colors.green.shade600 : Colors.teal,
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isCheapest ? Colors.green.shade50 : Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.add_shopping_cart_rounded,
                              color: isCheapest ? Colors.green.shade700 : Colors.teal.shade600,
                              size: 18,
                            ),
                          ),
                        ),
                        if (!isSystemProduct) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _showDeleteDialog(context, product),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade600, size: 18),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Kaydı Sil"),
        content: Text("${product.market} marketine ait bu fiyat kaydı silinecek. Emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Vazgeç")),
          TextButton(
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false).removeProduct(product.id!, barcode);
              Navigator.pop(context);
            },
            child: const Text("Sil", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text("Bu barkoda ait bir veri bulunamadı.", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _goToAddPage(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text("Yeni Ürün Olarak Ekle"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: OutlinedButton.icon(
        onPressed: () => _goToAddPage(context),
        icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.teal),
        label: const Text("Başka Bir Seçenek Ekle", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: Colors.teal, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  void _goToAddPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen(barcode: barcode)));
  }
}