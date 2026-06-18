import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';
import 'database_helper.dart';

class ProductDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Ürün Ekleme
  Future<int> insertProduct(Product product) async {
    final db = await _dbHelper.database;
    return await db.insert('products', product.toMap());
  }

  // Barkoda göre ürünleri getir (Modern Barkod Özelliği İçin)
  Future<List<Product>> getProductsByBarcode(String barcode) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  // Tüm ürünleri listele
  Future<List<Product>> getAllProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  // Tek bir ürünü silmek için (Kriter 3)
  Future<int> deleteProduct(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

// Tüm veritabanını temizlemek için
  Future<int> deleteAllProducts() async {
    final db = await _dbHelper.database;
    return await db.delete('products');
  }
}