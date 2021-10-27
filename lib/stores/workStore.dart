import 'dart:io';

import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/remote/abstractWarehouseSystem.dart';
import 'package:wms_app/remote/warehouseSystem.dart';
import 'package:wms_app/remote/productsSource.dart';

class WorkStore {
  AbstractWarehouseSystem warehouseSystem = WarehouseSystem();

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
      print(element.getName());
    });

    return Sequence(products);
  }

  Future<Product> product(String ean) => warehouseSystem.getProduct(ean);

/*
  Sequence getRegistration() {
    return null;
  }

  Sequence getCounting() {
    return null;
  }
  */
}
