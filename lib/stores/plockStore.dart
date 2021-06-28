import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/abstractProductsSource.dart';
import 'package:wms_app/stores/mockProductsSource.dart';

// never interact directly with stores, services - always get them via dep

class PlockStore {
  List<Product> productItems;
  Iterator<Product> collect;

  AbstractProductsSource productsSource = MockProductsSource();

  PlockStore() {
    productItems = productsSource.getProducts();
    collect = productItems.iterator;
    //// create ISource and swap local mock, to remote mock and remote products, try catch
  }
}
