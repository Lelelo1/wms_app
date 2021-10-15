// abstract unit wms app interacts with

import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/abstractWarehouseSystem.dart';
import 'package:wms_app/remote/productsSource.dart';
import 'package:wms_app/views/productView.dart';

import '../utils.dart';

// how to connect and disconnect in each method, without writing it in each

class WarehouseSystem implements AbstractWarehouseSystem {
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
    /*
    var connection = await _productsSource.connect();

    if (connection == null) {
      print("did not get a connection to warehousesystem, timed out");
      return null;
    }

    var product = await this._productsSource.getProduct(connection, ean);

    await _productsSource.disconnect(connection);
    return product;
    */

    return interact(
        (connection) => this._productsSource.getProduct(connection, ean));
  }

  Future<List<String>> getSKUSuggestions(String text) async {
    if (Utils.isNullOrEmpty(text)) {
      return null;
    }

    /*
    var connection = await _productsSource.connect();

    if (connection == null) {
      print("did not get a connection to warehousesystem, timed out");
      return null;
    }

    var skuSuggestions =
        await this._productsSource.getSKUSuggestions(connection, text);

    await _productsSource.disconnect(connection);

    return skuSuggestions;
    */

    return interact((connection) =>
        this._productsSource.getSKUSuggestions(connection, text));
  }

  // some sort of error handling and make more cleaner?
  Future<T> interact<T>(
      Future<T> Function(MySqlConnection connection) action) async {
    var connection = await _productsSource.connect();
    var result = await action(connection);
    _productsSource.disconnect(connection);
    return result;
  }
}
