// abstract unit wms app interacts with

import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/productsSource.dart';
import 'package:wms_app/views/productView.dart';

// how to connect and disconnect in each method, without writing it in each

class WarehouseSystem {
  ProductsSource _productsSource = ProductsSource();
  Future<List<Product>> getProducts() async {
    /*
    // not implemented
    var connection = await _productsSource.connect();

    if (connection == null) {
      print("did not get a connection to warehousesystem, timed out");
      return null;
    }
    var products = await _productsSource.getProducts(connection);
    await _productsSource.disconnect(connection);
    */
    return null;
  }

  Future<Product> getProduct(String ean) async {
    var connection = await _productsSource.connect();

    if (connection == null) {
      print("did not get a connection to warehousesystem, timed out");
      return null;
    }

    var product = await this._productsSource.getProduct(connection, ean);

    await _productsSource.disconnect(connection);
    return product;
  }
  //Future<Int>
}
