// there is no interfaces in dart, and abstract class seem to have 'AbstractSomething' as naming convention: https://stackoverflow.com/questions/6861671/abstract-class-naming-convention
import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/product.dart';

abstract class AbstractProductsSource {
  Future<MySqlConnection> connect();
  Future<void> disconnect(MySqlConnection connection);
  Future<List<Product>> getProducts(MySqlConnection connection);
}
