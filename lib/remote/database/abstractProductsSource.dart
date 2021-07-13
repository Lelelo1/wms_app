// there is no interfaces in dart, and abstract class seem to have 'AbstractSomething' as naming convention: https://stackoverflow.com/questions/6861671/abstract-class-naming-convention
import 'package:wms_app/models/product.dart';

abstract class AbstractProductsSource {
  List<Product> _products;
  Future<List<Product>> getProducts();
}
