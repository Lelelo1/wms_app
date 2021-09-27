// abstract unit wms app interacts with

import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/abstractProductsSource.dart';
import 'package:wms_app/remote/productsSource.dart';
import 'package:wms_app/views/productView.dart';

class WarehouseSystem {
  AbstractProductsSource warehouseSystem = ProductsSource();
  Future<List<Product>> getProducts() async {
    var connection = await warehouseSystem.connect();

    if (connection == null) {
      print("did not get a connection to warehousesystem, timed out");
      return null;
    }
    var products = await warehouseSystem.getProducts(connection);
    await warehouseSystem.disconnect(connection);

    return products;
  }
}
