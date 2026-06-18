import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product_model.dart';
import 'home_screen.dart'; // 🎯 YENİ: HomeScreen import edildi

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiyat Arşivi'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        // 🎯 YENİ: Tek tıkla tüm geçmişi silip Ana Menüye ışınlayan Ev Butonu eklendi!
        actions: [
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
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: ProductRepository().fetchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Henüz kayıtlı ürün yok."));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(p.name),
                subtitle: Text("${p.market} - ${p.price} TL"),
                trailing: Text(p.unit),
              );
            },
          );
        },
      ),
    );
  }
}