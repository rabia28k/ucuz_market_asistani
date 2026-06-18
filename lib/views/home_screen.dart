import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_provider.dart';
import '../viewmodels/cart_provider.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';
import 'result_screen.dart';
import 'categories_screen.dart';
import 'cart_screen.dart';
import 'main_navigator.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _barcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.teal.shade700),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person_outline_rounded, size: 40, color: Colors.teal),
              ),
              accountName: const Text(
                  "Profil Hesabı",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              accountEmail: const Text("Aktif Oturum Açık"),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.teal),
              title: const Text("Ana Sayfa"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.teal),
              title: const Text("Akıllı Sepetim"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.teal),
              title: const Text("Fiyat Geçmişi"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.teal),
              title: const Text("Hakkında"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            )
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  const Icon(
                    Icons.shopping_basket_outlined,
                    size: 70,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "UcuzMarket",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "En Uygun Paketi Anında Bul",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Icons.edit, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _barcodeController,
                            decoration: const InputDecoration(
                              hintText: 'Barkod No Giriniz (Örn: 111,...)',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_barcodeController.text.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(barcode: _barcodeController.text),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.search, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("VEYA", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ButtonTheme(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                        );
                      },
                      icon: const Icon(Icons.grid_view_rounded, color: Colors.teal),
                      label: const Text(
                        "Ürün Kataloğundan Seç",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Consumer<CartProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.shopping_cart_outlined, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      "Akıllı Sepetim",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${provider.cartItems.length} Ürün",
                                    style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Divider(color: Colors.white24, height: 1),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Sepetteki Toplam Tutar:", style: TextStyle(color: Colors.white70)),
                                Text(
                                  "${provider.totalCartPrice.toStringAsFixed(2)} TL",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CartScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.teal.shade800,
                                minimumSize: const Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                elevation: 0,
                              ),
                              child: const Text("Sepeti Görüntüle ve Optimize Et", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.local_fire_department_rounded, color: Colors.amber),
                      SizedBox(width: 5),
                      Text(
                        "Günün En Avantajlı Fırsatları",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildPromoCard("Süt Ürünleri", "%15 İndirim", Icons.egg_alt_outlined, "Süt Ürünleri"),
                        _buildPromoCard("Bakliyatlar", "En Ucuz Birim", Icons.cookie_outlined, "Bakliyat"),
                        _buildPromoCard("Temizlik", "Market Kıyasla", Icons.clean_hands_outlined, "Temizlik"),
                        _buildPromoCard("Temel Gıda", "Bütçe Dostu", Icons.rice_bowl_outlined, "Temel Gıda"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard(String title, String subtitle, IconData icon, String categoryName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesScreen(selectedCategory: categoryName),
          ),
        );
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.teal.shade700, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: Colors.green.shade700, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}