import 'dart:io';

import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/remote/abstractWarehouseSystem.dart';
import 'package:wms_app/remote/warehouseSystem.dart';

class WorkStore {
  /*Abstract*/ WarehouseSystem _warehouseSystem = WarehouseSystem();

  // how to interact with ui error message?

  Future<Product> product(String ean) => _warehouseSystem.getProduct(ean);

  Future<List<String>> suggestions(String text) =>
      _warehouseSystem.getSKUSuggestions(text);

  Future<T> attribute<T>(int id, Attribute attribute) =>
      _warehouseSystem.attribute<T>(id, attribute);
/*
  Sequence getRegistration() {
    return null;
  }

  Sequence getCounting() {
    return null;
  }
  */
}
