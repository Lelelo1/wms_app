import 'dart:io';

import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/remote/abstractProductsSource.dart';
import 'package:wms_app/remote/productsSource.dart';

class WorkStore {
  WarehouseSystem warehouseSystem = WarehouseSystem();
  
  // how to interact with ui error message?

  Future<Sequence> getCollection() async {
    List<Product> products;
    try {
      products = await warehouseSystem.getProducts();
    } on SocketException catch (socketException) {
      // not on wifi
      print("you have to be connected to wifi!!");
    }

    products.forEach((element) {
      print(element.name);
    });

    return Sequence(products);
  }

  Sequence getRegistration() {
    return null;
  }

  Sequence getCounting() {
    return null;
  }
}
