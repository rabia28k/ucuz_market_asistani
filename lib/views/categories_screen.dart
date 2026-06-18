import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_provider.dart';
import 'result_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final String? selectedCategory;

  const CategoriesScreen({super.key, this.selectedCategory});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, String>> _allProducts = [
    {'name': 'Sütaş Kaşar Peyniri', 'barcode': '2121', 'icon': '🧀', 'cat': 'Süt Ürünleri'},
    {'name': 'Şampuan Çeşitleri', 'barcode': '2020', 'icon': '⚗️', 'cat': 'Kişisel Bakım'},
    {'name': 'Sıvı Sabunlar', 'barcode': '1919', 'icon': '🧼', 'cat': 'Kişisel Bakım'},
    {'name': 'Pilavlık Bulgur', 'barcode': '1818', 'icon': '🌾', 'cat': 'Bakliyat'},
    {'name': 'Kırmızı Mercimek', 'barcode': '1717', 'icon': '🥣', 'cat': 'Bakliyat'},
    {'name': 'Un Çetahui', 'barcode': '1616', 'icon': '🍞', 'cat': 'Temel Gıda'},
    {'name': 'Tuz Çeşitleri', 'barcode': '1515', 'icon': '🧂', 'cat': 'Temel Gıda'},
    {'name': 'Domates Salçası', 'barcode': '1414', 'icon': '🥫', 'cat': 'Temel Gıda'},
    {'name': 'Ayran Çeşitleri', 'barcode': '1313', 'icon': '🥛', 'cat': 'Süt Ürünleri'},
    {'name': 'Kahve Çeşitleri', 'barcode': '1212', 'icon': '☕', 'cat': 'İçecekler'},
    {'name': 'Yoğurt Çeşitleri', 'barcode': '1111', 'icon': '🥛', 'cat': 'Süt Ürünleri'},
    {'name': 'Yumurta Çeşitleri', 'barcode': '1010', 'icon': '🥚', 'cat': 'Temel Gıda'},
    {'name': 'Zeytin Çeşitleri', 'barcode': '999', 'icon': '🫒', 'cat': 'Temel Gıda'},
    {'name': 'Toz Şeker Çeşitleri', 'barcode': '888', 'icon': '🍬', 'cat': 'Temel Gıda'},
    {'name': 'Filiz / Ankara Makarna', 'barcode': '777', 'icon': '🍝', 'cat': 'Temel Gıda'},
    {'name': 'Çay Çeşitleri', 'barcode': '666', 'icon': '🍂', 'cat': 'İçecekler'},
    {'name': 'Deterjan Çeşitleri', 'barcode': '555', 'icon': '🧺', 'cat': 'Temizlik'},
    {'name': 'Pilavlık Pirinç', 'barcode': '444', 'icon': '🍚', 'cat': 'Bakliyat'},
    {'name': 'Sütaş / Dost Süt 1L', 'barcode': '333', 'icon': '🥛', 'cat': 'Süt Ürünleri'},
    {'name': 'Ayçiçek Yağı 5L', 'barcode': '222', 'icon': '🛢️', 'cat': 'Temel Gıda'},
    {'name': 'Tuvalet Kağıdı Çeşitleri', 'barcode': '111', 'icon': '🧻', 'cat': 'Temizlik'},
  ];

  List<Map<String, String>> _filteredProducts = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.selectedCategory != null) {
      _filteredProducts = _allProducts.where((product) {
        return product['cat'] == widget.selectedCategory;
      }).toList();
    } else {
      _filteredProducts = _allProducts;
    }
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        if (widget.selectedCategory != null) {
          _filteredProducts = _allProducts.where((p) => p['cat'] == widget.selectedCategory).toList();
        } else {
          _filteredProducts = _allProducts;
        }
      } else {
        _filteredProducts = _allProducts.where((product) {
          final productName = product['name']!.toLowerCase();
          final searchLower = query.toLowerCase();

          if (widget.selectedCategory != null) {
            return product['cat'] == widget.selectedCategory &&
                (productName.startsWith(searchLower) || productName.contains(searchLower));
          }

          return productName.startsWith(searchLower) || productName.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Ürün adı ara...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          onChanged: _filterProducts,
        )
            : Text(
            widget.selectedCategory != null ? 'Katalog > ${widget.selectedCategory}' : 'Ürün Kataloğu',
            style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  if (widget.selectedCategory != null) {
                    _filteredProducts = _allProducts.where((p) => p['cat'] == widget.selectedCategory).toList();
                  } else {
                    _filteredProducts = _allProducts;
                  }
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: _filteredProducts.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                'Aradığınız ürün bulunamadı.',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: _filteredProducts.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final item = _filteredProducts[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade50,
                  radius: 25,
                  child: Text(item['icon']!, style: const TextStyle(fontSize: 24)),
                ),
                title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.teal.shade100, borderRadius: BorderRadius.circular(10)),
                      child: Text(item['cat']!, style: TextStyle(color: Colors.teal.shade800, fontSize: 11, fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 8),
                    Text('Barkod: ${item['barcode']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Provider.of<ProductProvider>(context, listen: false).searchByBarcode(item['barcode']!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultScreen(barcode: item['barcode']!)),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}