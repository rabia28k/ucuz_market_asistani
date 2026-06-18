import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../viewmodels/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  final String barcode;
  const AddProductScreen({super.key, required this.barcode});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _amountController = TextEditingController();
  final _marketController = TextEditingController();
  String _selectedUnit = 'gr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Fiyat Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Barkod: ${widget.barcode}", style: const TextStyle(color: Colors.grey)),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Ürün Adı (Örn: Tam Yağlı Süt)'), validator: (v) => v!.isEmpty ? 'Boş bırakılamaz' : null),
              TextFormField(controller: _marketController, decoration: const InputDecoration(labelText: 'Market Adı (Örn: A101, Şok)'), validator: (v) => v!.isEmpty ? 'Boş bırakılamaz' : null),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _amountController, decoration: const InputDecoration(labelText: 'Miktar'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedUnit,
                    items: <String>['kg', 'Litre', 'gr', 'ml', 'adet'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedUnit = newValue!;
                      });
                    },
                  )
                ],
              ),
              TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Fiyat (TL)'), keyboardType: TextInputType.number),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final p = Product(
                      name: _nameController.text,
                      barcode: widget.barcode,
                      price: double.parse(_priceController.text),
                      amount: double.parse(_amountController.text),
                      unit: _selectedUnit,
                      market: _marketController.text,
                    );
                    context.read<ProductProvider>().addNewProduct(p);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Veritabanına Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}