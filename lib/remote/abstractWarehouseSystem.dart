import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/models/product.dart';

abstract class AbstractWarehouseSystem {
  // arbitary view products (more fo a mock ui testing method)
  Future<List<AbstractProduct>> products();
  Future<AbstractProduct> product(String ean);
  Future<List<String>> skuSuggestions(String text);
  Future<T> attribute<T>(int id, Attribute attribute);
}
