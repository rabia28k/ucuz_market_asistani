import '../models/product_model.dart';
import 'product_dao.dart';

class ProductRepository {
  final ProductDao _productDao = ProductDao();
  Future<List<Product>> getProductsByBarcode(String barcode) async {
    return await _productDao.getProductsByBarcode(barcode);
  }

  // Silme işlemini de buraya eklemelisin (Provider'dan çağırabilmek için)
  Future<int> deleteProduct(int id) async {
    return await _productDao.deleteProduct(id);
  }

  Future<int> addProduct(Product product) async {
    return await _productDao.insertProduct(product);
  }

  Future<List<Product>> fetchAll() async {
    return await _productDao.getAllProducts();
  }
}