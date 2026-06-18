import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hakkında')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(Icons.info_outline, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            const Text("UcuzMarket v1.0", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Divider(),
            const Text(
              "Bu uygulama, tüketicilerin market ürünlerini birim fiyat (gramaj/fiyat) üzerinden kıyaslayarak en karlı alışverişi yapmalarını sağlamak amacıyla geliştirilmiştir.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text("Teknik Özellikler:", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("• Katmanlı Mimari (UI/Data/Business)"),
            const Text("• SQLite ile Yerel Veritabanı"),
            const Text("• Mobile Barcode Scanner Entegrasyonu"),
            const Text("• Provider ile State Management"),
            const Spacer(),
            const Center(child: Text("© 2026 Rabia Korkmaz - IAU Computer Engineering", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}