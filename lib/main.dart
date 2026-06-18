import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/product_provider.dart';
import 'viewmodels/cart_provider.dart';
import 'views/home_screen.dart';
import 'models/product_model.dart';
import 'data/product_repository.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await _prepareTestData();
  } catch (e) {
    debugPrint("Veritabanı başlatma hatası: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _prepareTestData() async {
  final repo = ProductRepository();
  final existingData = await repo.fetchAll();

  if (existingData.isEmpty) {
    await repo.addProduct(Product(name: "Papia 32'li", barcode: "111", price: 345.0, amount: 32, unit: "Adet", market: "Migros", healthScore: 8, ingredientsNote: "3 Katlı Saf Selüloz"));
    await repo.addProduct(Product(name: "Solo 24'lü", barcode: "111", price: 180.0, amount: 24, unit: "Adet", market: "BİM", healthScore: 6, ingredientsNote: "Standart Geri Dönüştürülmüş Selüloz"));
    await repo.addProduct(Product(name: "Familia 32'li", barcode: "111", price: 288.0, amount: 32, unit: "Adet", market: "A101", healthScore: 7, ingredientsNote: "Parfümlü Katkılı Yapı"));

    await repo.addProduct(Product(name: "Yudum 5L", barcode: "222", price: 215.0, amount: 5, unit: "Litre", market: "Tarım Kredi", healthScore: 5, ingredientsNote: "Rafine Ayçiçek Yağı"));
    await repo.addProduct(Product(name: "Sırma 2L", barcode: "222", price: 92.0, amount: 2, unit: "Litre", market: "Şok", healthScore: 5, ingredientsNote: "Yüksek Isıl İşlem Görmüş Yağ"));
    await repo.addProduct(Product(name: "Kırlangıç Sızma Zeytinyağı 1L", barcode: "222", price: 195.0, amount: 1, unit: "Litre", market: "Migros", healthScore: 10, ingredientsNote: "%100 Soğuk Sıkım Hakiki Zeytinyağı"));

    await repo.addProduct(Product(name: "Pınar Organik Süt 1L", barcode: "333", price: 48.0, amount: 1, unit: "Litre", market: "Carrefour", healthScore: 10, ingredientsNote: "%100 Organik Sertifikalı Çiftlik Sütü"));
    await repo.addProduct(Product(name: "Dost Süt 1L", barcode: "333", price: 29.5, amount: 1, unit: "Litre", market: "BİM", healthScore: 6, ingredientsNote: "UHT İşlem Görmüş Standart Süt"));
    await repo.addProduct(Product(name: "İçim Süt 1L", barcode: "333", price: 34.0, amount: 1, unit: "Litre", market: "Migros", healthScore: 7, ingredientsNote: "Pastörize Günlük Süt"));

    await repo.addProduct(Product(name: "Yayla Pirinç 2.5kg", barcode: "444", price: 145.0, amount: 2.5, unit: "kg", market: "Migros", healthScore: 6, ingredientsNote: "Standart Beyaz Baldo Pirinç"));
    await repo.addProduct(Product(name: "Efsane Pirinç 1kg", barcode: "444", price: 42.0, amount: 1, unit: "kg", market: "BİM", healthScore: 6, ingredientsNote: "İthal Yerli Pilavlık Pirinç"));
    await repo.addProduct(Product(name: "Duru Organik Esmer Pirinç 1kg", barcode: "444", price: 78.0, amount: 1, unit: "kg", market: "A101", healthScore: 9, ingredientsNote: "Glisemik İndeksi Düşük Yüksek Lifli Esmer Pirinç"));

    await repo.addProduct(Product(name: "Ariel 10kg", barcode: "555", price: 450.0, amount: 10, unit: "kg", market: "Trendyol", healthScore: 5, ingredientsNote: "Yoğun Parfümlü Kimyasal Formül"));
    await repo.addProduct(Product(name: "Frosch Ekolojik 5kg", barcode: "555", price: 310.0, amount: 5, unit: "kg", market: "A101", healthScore: 9, ingredientsNote: "Bitkisel Bazlı Hipolerjenik Vegan Deterjan"));
    await repo.addProduct(Product(name: "Persil 5kg", barcode: "555", price: 220.0, amount: 5, unit: "kg", market: "Şok", healthScore: 5, ingredientsNote: "Fosfat İçeren Standart Formül"));

    await repo.addProduct(Product(name: "Çaykur Rize 1kg", barcode: "666", price: 165.0, amount: 1, unit: "kg", market: "Migros", healthScore: 8, ingredientsNote: "Katkısız Doğal Siyah Çay Filizi"));
    await repo.addProduct(Product(name: "Lipton 1kg", barcode: "666", price: 180.0, amount: 1, unit: "kg", market: "Carrefour", healthScore: 7, ingredientsNote: "Aromatik Katkılı Harman Çay"));
    await repo.addProduct(Product(name: "Tirebolu Organik Çay 1kg", barcode: "666", price: 190.0, amount: 1, unit: "kg", market: "Yerel Market", healthScore: 10, ingredientsNote: "%100 Organik Karadeniz Çayı (Pestisitsiz)"));

    await repo.addProduct(Product(name: "Barilla Tam Buğday 500g", barcode: "777", price: 32.0, amount: 0.5, unit: "kg", market: "Migros", healthScore: 9, ingredientsNote: "%100 Tam Buğday İrmiğinden Yüksek Lifli"));
    await repo.addProduct(Product(name: "Ankara 500g", barcode: "777", price: 15.0, amount: 0.5, unit: "kg", market: "A101", healthScore: 6, ingredientsNote: "Beyaz Durum Buğdayı İrmiği"));
    await repo.addProduct(Product(name: "Filiz 500g", barcode: "777", price: 12.5, amount: 0.5, unit: "kg", market: "BİM", healthScore: 6, ingredientsNote: "Klasik Beyaz Makarna"));

    await repo.addProduct(Product(name: "Torku Şeker 5kg", barcode: "888", price: 165.0, amount: 5, unit: "kg", market: "Migros", healthScore: 4, ingredientsNote: "%100 Pancar Şekeri"));
    await repo.addProduct(Product(name: "Bor Şeker 5kg", barcode: "888", price: 145.0, amount: 5, unit: "kg", market: "BİM", healthScore: 3, ingredientsNote: "Rafine Beyaz Şeker"));
    await repo.addProduct(Product(name: "Splenda Bitkisel Tatlandırıcı 100g", barcode: "888", price: 95.0, amount: 0.1, unit: "kg", market: "A101", healthScore: 8, ingredientsNote: "Sıfır Kalorili Doğal Stevia Ekstresi"));

    await repo.addProduct(Product(name: "Marmarabirlik Organik 800g", barcode: "999", price: 215.0, amount: 0.8, unit: "kg", market: "Carrefour", healthScore: 9, ingredientsNote: "Az Tuzlu Doğal Fermantasyon Organik Zeytin"));
    await repo.addProduct(Product(name: "Inci Zeytin 1kg", barcode: "999", price: 160.0, amount: 1, unit: "kg", market: "Şok", healthScore: 5, ingredientsNote: "Yüksek Tuzlu ve Koruyuculu Hızlı Olgunlaştırma"));
    await repo.addProduct(Product(name: "Fora Zeytin 500g", barcode: "999", price: 95.0, amount: 0.5, unit: "kg", market: "Migros", healthScore: 6, ingredientsNote: "Pastörize Siyah Zeytin"));

    await repo.addProduct(Product(name: "Flotty Organik 10'lu", barcode: "1010", price: 85.0, amount: 10, unit: "Adet", market: "BİM", healthScore: 10, ingredientsNote: "0 Numaralı Kodlu Sertifikalı Organik Gezen Tavuk Yumurtası"));
    await repo.addProduct(Product(name: "Keskinoğlu 15'li", barcode: "1010", price: 65.0, amount: 15, unit: "Adet", market: "A101", healthScore: 5, ingredientsNote: "3 Numaralı Kafes Tavuğu Yumurtası"));
    await repo.addProduct(Product(name: "CP Yumurta 30'lu", barcode: "1010", price: 108.0, amount: 30, unit: "Adet", market: "Şok", healthScore: 5, ingredientsNote: "3 Numaralı Konvansiyonel Kümes Yumurtası"));

    await repo.addProduct(Product(name: "Sütaş Yoğurt 2kg", barcode: "1111", price: 85.0, amount: 2, unit: "kg", market: "Migros", healthScore: 7, ingredientsNote: "Standart Homojenize Yoğurt"));
    await repo.addProduct(Product(name: "Dost Yoğurt 3kg", barcode: "1111", price: 99.0, amount: 3, unit: "kg", market: "BİM", healthScore: 6, ingredientsNote: "Endüstriyel Katkısız Yoğurt"));
    await repo.addProduct(Product(name: "Aoç Organik Yoğurt 1kg", barcode: "1111", price: 68.0, amount: 1, unit: "kg", market: "A101", healthScore: 10, ingredientsNote: "Atatürk Orman Çiftliği Katkısız Geleneksel Maya Yoğurdu"));

    await repo.addProduct(Product(name: "Nescafe Gold 180g", barcode: "1212", price: 185.0, amount: 0.18, unit: "kg", market: "Migros", healthScore: 6, ingredientsNote: "Çözülebilir Hazır Granül Kahve"));
    await repo.addProduct(Product(name: "Jacobs Monarch 200g", barcode: "1212", price: 165.0, amount: 0.2, unit: "kg", market: "A101", healthScore: 6, ingredientsNote: "Dondurularak Kurutulmuş Hazır Kahve"));
    await repo.addProduct(Product(name: "Mehmet Efendi Filtre Kahve 250g", barcode: "1212", price: 95.0, amount: 0.25, unit: "kg", market: "BİM", healthScore: 9, ingredientsNote: "%100 Saf Arabica Öğütülmüş Çekirdek Kahve"));

    await repo.addProduct(Product(name: "Sütaş Ayran 2L", barcode: "1313", price: 48.0, amount: 2, unit: "Litre", market: "Migros", healthScore: 7, ingredientsNote: "Standart Kıvamlı Ayran"));
    await repo.addProduct(Product(name: "Dost Ayran 2L", barcode: "1313", price: 39.5, amount: 2, unit: "Litre", market: "BİM", healthScore: 6, ingredientsNote: "Klasik Tuzlu Ayran"));
    await repo.addProduct(Product(name: "Eker Organik Ayran 1L", barcode: "1313", price: 45.0, amount: 1, unit: "Litre", market: "Şok", healthScore: 10, ingredientsNote: "Kültürlü Organik Yoğurttan Kaya Tuzlu Temiz Ayran"));

    await repo.addProduct(Product(name: "Tat Salça 830g", barcode: "1414", price: 42.0, amount: 0.83, unit: "kg", market: "Migros", healthScore: 8, ingredientsNote: "Güneşte Kurutulmuş İlave Tuzsuz Salça"));
    await repo.addProduct(Product(name: "Tukaş Salça 700g", barcode: "1414", price: 34.0, amount: 0.7, unit: "kg", market: "A101", healthScore: 7, ingredientsNote: "Endüstriyel Koruyuculu Domates Salçası"));
    await repo.addProduct(Product(name: "Wefood Organik Salça 500g", barcode: "1414", price: 89.0, amount: 0.5, unit: "kg", market: "Tarım Kredi", healthScore: 10, ingredientsNote: "Sertifikalı Ev Yapımı Mevsimlik Organik Domates Salçası"));

    await repo.addProduct(Product(name: "Billur İyotlu Tuz 750g", barcode: "1515", price: 18.0, amount: 0.75, unit: "kg", market: "Migros", healthScore: 5, ingredientsNote: "Rafine Edilmiş Akışkan Kimyasal Katkılı Sofra Tuzu"));
    await repo.addProduct(Product(name: "Kayı Gerçek Çankırı Kaya Tuzu 1kg", barcode: "1515", price: 45.0, amount: 1, unit: "kg", market: "BİM", healthScore: 10, ingredientsNote: "84 Mineralli Rafine Edilmemiş Saf Kristal Kaya Tuzu"));

    await repo.addProduct(Product(name: "Söke Un 5kg", barcode: "1616", price: 95.0, amount: 5, unit: "kg", market: "Migros", healthScore: 6, ingredientsNote: "Beyazlatılmış Rafine Ekmeklik Un"));
    await repo.addProduct(Product(name: "Efsane Un 10kg", barcode: "1616", price: 160.0, amount: 10, unit: "kg", market: "BİM", healthScore: 5, ingredientsNote: "Endüstriyel Tip Beyaz Un"));
    await repo.addProduct(Product(name: "Sinangil Tam Buğday Unu 2kg", barcode: "1616", price: 58.0, amount: 2, unit: "kg", market: "Şok", healthScore: 9, ingredientsNote: "Ruşeymi ve Kepeği Ayrılmamış Taş Değirmen Tam Buğday Unu"));

    await repo.addProduct(Product(name: "Yayla Kırmızı Mercimek 1kg", barcode: "1717", price: 54.0, amount: 1, unit: "kg", market: "Migros", healthScore: 8, ingredientsNote: "Cilalanmamış Yerli Kırmızı Mercimek"));
    await repo.addProduct(Product(name: "Saban Mercimek 2.5kg", barcode: "1717", price: 110.0, amount: 2.5, unit: "kg", market: "BİM", healthScore: 7, ingredientsNote: "İthal Kanada Tipi Kırmızı Mercimek"));

    await repo.addProduct(Product(name: "Duru Başbaşı Bulgur 1kg", barcode: "1818", price: 38.0, amount: 1, unit: "kg", market: "Migros", healthScore: 9, ingredientsNote: "Geleneksel Yöntemle Taş Değirmende Kırılmış Sarı Bulgur"));
    await repo.addProduct(Product(name: "Tat Bulgur 2kg", barcode: "1818", price: 62.0, amount: 2, unit: "kg", market: "A101", healthScore: 8, ingredientsNote: "Standart Pilavlık Bulgur"));

    await repo.addProduct(Product(name: "Palmolive 500ml", barcode: "1919", price: 75.0, amount: 0.5, unit: "Litre", market: "Migros", healthScore: 5, ingredientsNote: "Paraben ve SLS İçeren Yoğun Kimyasal Esans"));
    await repo.addProduct(Product(name: "Sarıyer Doğal Zeytinyağlı Sabun 1L", barcode: "1919", price: 95.0, amount: 1, unit: "Litre", market: "Şok", healthScore: 9, ingredientsNote: "%100 Saf Zeytinyağı Özlü Bitkisel Kimyasalsız Formül"));

    await repo.addProduct(Product(name: "Elidor 400ml", barcode: "2020", price: 95.0, amount: 0.4, unit: "Litre", market: "A101", healthScore: 4, ingredientsNote: "Sülfat ve Silikon Tabanlı Saç Kremli Şampuan"));
    await repo.addProduct(Product(name: "Clear 600ml", barcode: "2020", price: 145.0, amount: 0.6, unit: "Litre", market: "Migros", healthScore: 4, ingredientsNote: "Kepek Karşıtı Ağır Kimyasal Active Maddeler"));
    await repo.addProduct(Product(name: "Otacı Bitkisel Şampuan 400ml", barcode: "2020", price: 160.0, amount: 0.4, unit: "Litre", market: "BİM", healthScore: 10, ingredientsNote: "Sülfatsız, Tuzsuz, Parabensiz Tamamen Doğal Çay Ağacı Özlü"));

    await repo.addProduct(Product(name: "Sütaş Eski Kaşar 350g", barcode: "2121", price: 180.0, amount: 0.35, unit: "kg", market: "Migros", healthScore: 9, ingredientsNote: "6 Ay Şirden Maya ile Olgunlaştırılmış Hakiki Kaşar"));
    await repo.addProduct(Product(name: "Binvezir Tost Peyniri 1kg", barcode: "2121", price: 245.0, amount: 1, unit: "kg", market: "BİM", healthScore: 4, ingredientsNote: "Yoğun Eritme Tuzu ve Bitkisel Yağ Katkılı Tost Peyniri"));

    debugPrint("SQLite: 21 tane yenilikçi ve sağlık puanlı ürün veritabanına başarıyla yüklendi.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UcuzMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}