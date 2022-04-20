import 'dart:async';

import 'package:mysql1/src/single_connection.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/abstractWarehouseSystem.dart';

class MockWarehouseSystem extends AbstractWarehouseSystem {
  @override
  Future<MySqlConnection?> connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future? disconnect(MySqlConnection? connection) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<T>?> fetchAttribute<T>(int id, String attribute) {
    // TODO: implement fetchAttribute
    throw UnimplementedError();
  }

  @override
  Future<Product> fetchProduct(String ean) {
    // TODO: implement fetchProduct
    throw UnimplementedError();
  }

  @override
  Future<double> fetchQuantity(String entityId) {
    // TODO: implement fetchQuantity
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> fetchSuggestions(String text) {
    // TODO: implement fetchSuggestions
    throw UnimplementedError();
  }

  @override
  Future<String> findShelf(String scanData) {
    // TODO: implement findShelf
    throw UnimplementedError();
  }

  @override
  void increaseAmountOfProducts(Product product) {
    // TODO: implement increaseAmountOfProducts
  }

  @override
  void setEAN(int id, String ean) {
    // TODO: implement setEAN
  }

  @override
  Future<void> setShelf(Product product, String shelf) {
    // TODO: implement setShelf
    throw UnimplementedError();
  }
}
