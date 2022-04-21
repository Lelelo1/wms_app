import 'dart:io';

import 'package:git_info/git_info.dart';
import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/abstractWarehouseSystem.dart';
import 'package:wms_app/remote/deserialization.dart';
import 'package:wms_app/remote/sqlQuery.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';
import 'package:wms_app/stores/versionStore.dart';

import '../utils.dart';
/*
// https://pub.dev/packages/mysql1
class WarehouseSystem implements AbstractWarehouseSystem {
  static late WarehouseSystem instance = WarehouseSystem._();

  WarehouseSystem._();
  
  }


  Future<Product> fetchProduct(String ean) async {
    Results? results;
    var sql = SQLQuery.fetchProduct(ean);
    print(sql);
    results = await _interact((connection) => connection?.query(sql));
    var products =
        Deserialization.products(results); // shoudl haev zero or one hit

    if (products.isEmpty) {
      return Product.empty();
    }
    return products[0];
  }

  Future<List<Product>> fetchSuggestions(String text) async {
    var results = await _interact((connection) =>
        connection?.query(SQLQuery.fetchProductSuggestions(text)));

    return Deserialization.products(results);
  }

  Future<List<T>?> fetchAttribute<T>(int id, String attribute) async {
    var q = SQLQuery.fetchAttribute(id.toString(), attribute);
    print("q..: " + q);
    var results = await _interact((connection) => connection?.query(q));

    print(attribute + " " + results.toString());

    if (results == null) {
      return List.empty();
    }

    return results.map<T>((e) => e[0]).toList();
  }

  void setEAN(int id, String ean) async {
    var q = SQLQuery.setEAN(id.toString(), ean);
    print(q);
    await _interact((connection) => connection?.query(q));
  }

  void increaseAmountOfProducts(Product product) async {
    var increaseQuery = SQLQuery.increaseAmountOfProduct(product.id.toString());
    increaseQuery.forEach((q) {
      print(q);
    });
    await _interact((connection) {
      increaseQuery.forEach((q) {
        connection?.query(q);
      });
    });
  }

  Future<String> findShelf(String scanData) async {
    var q = SQLQuery.findShelf(scanData);
    print(q);

    var results = await _interact((connection) => connection?.query(q));

    if (results == null) {
      return Future.sync(() => "");
    }

    var shelfs = results.map((e) => e[0]).toList();

    if (shelfs.isEmpty) {
      return Future.sync(() => "");
    }

    return shelfs[0];
  }

  Future<double> fetchQuantity(String entityId) async {
    var q = SQLQuery.quantity(entityId);
    print("q..: " + q);
    var results = await _interact((connection) => connection?.query(q));

    return Deserialization.quantity(results);
  }

  Future<void> setShelf(Product product, String shelf) {
    var q = SQLQuery.setShelf(product.id.toString(), shelf);
    print("q..: " + q);
    return _interact((connection) => connection?.query(q));
  }
}
*/