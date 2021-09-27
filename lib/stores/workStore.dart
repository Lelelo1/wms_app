import 'dart:io';

import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/remote/abstractProductsSource.dart';
import 'package:wms_app/remote/productsSource.dart';

class WorkStore {
  AbstractProductsSource abstractSource = ProductsSource();

  Future<Sequence> getCollection() async {
    List<Product> products;
    try {
      products = await abstractSource.getProducts();
    } on SocketException catch (socketException) {
      // not on wifi
    }
    return Sequence(products);
  }

  Sequence getRegistration() {
    return null;
  }

  Sequence getCounting() {
    return null;
  }
}
