// abstract unit wms app interacts with

import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/abstractProductsSource.dart';
import 'package:wms_app/remote/productsSource.dart';
import 'package:wms_app/views/productView.dart';

// how to connect and disconnect in each method, without writing it in each

class WarehouseSystem {
  AbstractProductsSource productsSource = ProductsSource();
  Future<List<Product>> getProducts() async {
    var connection = await productsSource.connect();

    if (connection == null) {
      print("did not get a connection to warehousesystem, timed out");
      return null;
    }
    var products = await productsSource.getProducts(connection);
    await productsSource.disconnect(connection);

    return products;
  }

  Future<Product> getProduct(String ean) async {
    var connection = await productsSource.connect();

    if (connection == null) {
      print("did not get a connection to warehousesystem, timed out");
      return null;
    }

    await productsSource.disconnect(connection);
    return null;
  }
}
