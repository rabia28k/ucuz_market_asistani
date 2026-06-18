# ucuz_market_asistani
🛒 Akıllı Market Sepeti ve Bütçe Asistanı
Bu proje, tüketicilerin zincir marketler arasındaki fiyat farklılıklarını analiz etmesini, bütçe optimizasyonu yapmasını ve en ekonomik sepet kombinasyonunu oluşturmasını sağlayan bir mobil alışveriş asistanı uygulamasıdır.

🎯 Projenin Temel İşlevleri
Katalog & Kategori Filtreleme: Ana sayfadaki "Günün En Avantajlı Fırsatları" panelinden (Örn: Bakliyat) seçilen çeşitlerin ve en uygun marketlerin dinamik olarak listelenmesi.

Yapay Zeka Fiyat Kıyaslama: Ürün sorgulamalarında en ekonomik seçeneği otomatik belirleyen analiz kartı ve market fiyat sıralaması.

Akıllı Sepet & Bütçe Kontrolü: Tanımlanan bütçe sınırı aşıldığında arayüzde anlık kırmızı uyarı verilmesi ve sepet üzerinden sağlanan "Elde Edilen Toplam Kâr" miktarının canlı hesaplanması.

Dinamik Fiyat/Seçenek Ekleme: Veritabanında olmayan yeni bir ürünün veya fiyat alternatifinin (Örn: Öncü Domates Salçası) form aracılığıyla SQLite'a anlık kaydedilmesi.

🛠️ Teknik Altyapı
Framework & Dil: Flutter SDK & Dart

Veritabanı: SQLite (sqflite) ile yerel veri kalıcılığı

Durum Yönetimi: Provider mimarisi ile asenkron UI takibi

Tasarım Deseni: Temiz Katmanlı Mimari (UI -> Provider -> Repository -> DAO -> SQLite)
