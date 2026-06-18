import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ucuzmarket.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // --- TABLOLARIN OLUŞTURULMASI ---
  Future _onCreate(Database db, int version) async {
    // 1. Ürünler Tablosu
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        barcode TEXT,
        price REAL,
        amount REAL,
        unit TEXT,
        market TEXT,
        healthScore INTEGER,
        ingredientsNote TEXT
      )
    ''');

    // 2. Kullanıcılar Tablosu
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  } // <--- _onCreate metodu burada bitti!

  // =======================================================
  // --- KULLANICI OTURUM İŞLEMLERİ (Dışarıya Açık Metodlar) ---
  // =======================================================

  // 1. Yeni Kullanıcı Kaydet (Register)
  Future<int> registerUser(String email, String password) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'email': email,
        'password': password,
      });
    } catch (e) {
      return -1; // Eğer e-posta zaten varsa UNIQUE kısıtlamasından hata döner
    }
  }

  // 2. Kullanıcı Kontrol Et (Login)
  Future<bool> loginCheck(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return maps.isNotEmpty;
  }

// =======================================================
// --- ÜRÜN İŞLEMLERİ (Mevcut Diğer Metodların Buradan Devam Etmeli) ---
// =======================================================

// Not: Senin önceden yazdığın addProduct, getProductsByBarcode gibi
// ürün metodların varsa onları da bu satırın hemen altına ekleyebilirsin.
}