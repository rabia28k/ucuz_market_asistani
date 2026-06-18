class Product {
  final int? id;
  final String name;     // Ürün adı (örn: Süt)
  final String barcode;  // Barkod numarası
  final double price;    // Fiyatı
  final double amount;   // Miktarı (Gram veya ML)
  final String unit;     // Birimi (gr, ml, adet)
  final String market;   // Market adı (BİM, A101 vb.)

  // İNOVATİF SAĞLIK KATMANI ALANLARI
  final int healthScore;       // Sağlık Puanı: 1-10 arası (10 en sağlıklı/katkısız)
  final String ingredientsNote; // İçindekiler Notu: (Örn: "Palm Yağı İçermez", "Yüksek Şeker")

  Product({
    this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.amount,
    required this.unit,
    required this.market,
    this.healthScore = 5, // Varsayılan değer (Eski veriler patlamasın diye)
    this.ingredientsNote = "Standart İçerik Bilgisi",
  });

  // Birim fiyat hesaplama (En ucuzu bulmak için kritik fonksiyon!)
  double get unitPrice => price / amount;

  // Veritabanına kaydetmek için Map formatına çeviriyoruz
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'price': price,
      'amount': amount,
      'unit': unit,
      'market': market,
      'healthScore': healthScore,
      'ingredientsNote': ingredientsNote,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      price: map['price'],
      amount: map['amount'],
      unit: map['unit'],
      market: map['market'],
      healthScore: map['healthScore'] ?? 5,
      ingredientsNote: map['ingredientsNote'] ?? "Standart İçerik Bilgisi",
    );
  }
}