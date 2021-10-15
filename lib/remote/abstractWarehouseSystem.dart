import 'package:wms_app/models/product.dart';

abstract class AbstractWarehouseSystem {
  // arbitary view products (more fo a mock ui testing method)
  Future<List<AbstractProduct>> getProducts();
  Future<AbstractProduct> getProduct(String ean);
  Future<List<String>> getSKUSuggestions(String text);
}
