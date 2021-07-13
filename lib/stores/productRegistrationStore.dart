import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/database/abstractProductsSource.dart';
import 'package:wms_app/remote/database/mockProductsSource.dart';

// never interact directly with stores, services - always get them via dep

// consider having 'CollectStore' existing per

class ProductRegistrationStore {
  List<Product> productItems;

  AbstractProductsSource productsSource = MockProductsSource();

  // sets up products for a new collection
  Future<bool> setupCollection() async {
    productItems = await productsSource.getProducts();
    //collect = productItems.iterator;

    return Future.value(null);
  }
}
