import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_provider.dart';
import 'result_screen.dart'; // Sonuç ekranı

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Barkodunu Okut')),
      body: MobileScanner(
        // Barkod algılandığında çalışacak fonksiyon
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              final String code = barcode.rawValue!;

              // Provider üzerinden aramayı başlat
              Provider.of<ProductProvider>(context, listen: false).searchByBarcode(code);

              // Sonuç ekranına yönlendir
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ResultScreen(barcode: code)),
              );
              break;
            }
          }
        },
      ),
    );
  }
}