import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/database/abstractProductsSource.dart';
import 'package:wms_app/remote/database/mockProductsSource.dart';

// never interact directly with stores, services - always get them via dep

class CollectStore {
  List<Product> productItems;
  Iterator<Product> collect;

  AbstractProductsSource productsSource = MockProductsSource();

  CollectStore() {
    productItems = productsSource.getProducts();
    collect = productItems.iterator;
    // create ISource and swap local mock, to remote mock and remote products, try catch
  }
}
