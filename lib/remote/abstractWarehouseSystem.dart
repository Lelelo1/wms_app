import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/models/product.dart';

abstract class AbstractWarehouseSystem {
  Future<MySqlConnection?> connect();
  Future<dynamic>? disconnect(MySqlConnection? connection);
  Future<Product> fetchProduct(String ean);
  Future<List<Product>> fetchSuggestions(String text);
  Future<List<T>?> fetchAttribute<T>(int id, String attribute);
  void setEAN(int id, String ean);
  void increaseAmountOfProducts(Product product);
  Future<String> findShelf(String scanData);
  Future<double> fetchQuantity(String entityId);
  Future<void> setShelf(Product product, String shelf);
}
