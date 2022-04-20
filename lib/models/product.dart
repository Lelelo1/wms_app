// having objects tied directly to warehousesystem/database

import 'package:event/event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/remote/warehouseSystem.dart';
import 'package:wms_app/stores/workStore.dart';
import '../utils.dart';
import 'package:collection/collection.dart';

import 'abstractProduct.dart';

// potentially remove the '?' operator so default values can used. Which I guess
// is the reason for the null safety anyway

class Product extends AbstractProduct {
  @override
  int id = 0;

  Product(this.id);

  Product.empty() {
    id = 0;
  }

  bool exists() => id > 0;

  @override
  Future<String> getEAN() async {
    var ean = (await WarehouseSystem.instance
            .fetchAttribute<String>(id, Attributes.ean))
        ?.firstOrNull;
    return Utils.defaultString(ean, "-");
  }

  static String katsumiImages = "https://www.katsumi.se/media/catalog/product/";

  @override
  Future<List<String>> getImages() async {
    var imgs = await WarehouseSystem.instance
        .fetchAttribute<String>(id, Attributes.images);
    // potentially specify a fallback image, error image eg.
    return Utils.defaultImages(imgs).map((e) => katsumiImages + e).toList();
  }

  @override
  Future<String> getName() async {
    var name = (await WarehouseSystem.instance
            .fetchAttribute<String>(id, Attributes.name))
        ?.firstOrNull;
    return Utils.defaultString(name, "-");
  }

  @override
  Future<String> getSKU() async {
    var sku =
        (await WarehouseSystem.instance.fetchAttribute(id, Attributes.sku))
            ?.firstOrNull;
    return Utils.defaultString(sku, "-");
  }

  @override
  Future<String> getShelf() async {
    var shelf = (await WarehouseSystem.instance
            .fetchAttribute<String?>(id, Attributes.shelf))
        ?.firstOrNull;
    return Utils.defaultString(shelf, "-");
  }

  @override
  Future<double> getQuanity() async {
    var quantity =
        (await WarehouseSystem.instance.fetchQuantity(id.toString()));

    return quantity;
  }

  @override
  Future<void> setEAN(String ean) {
    // TODO: implement setEAN
    // set ean to the product in the warehousesystem
    return Future.sync(() => null);
  }

  Future<String> futureToString() async {
    var id = this.id.toString();
    var ean = await this.getEAN();
    var images = await this.getImages();
    var name = await this.getName();
    var sku = await this.getSKU();
    var shelf = await this.getShelf();

    return "id: " +
        id.toString() +
        ", ean: " +
        ean.toString() +
        ", images: " +
        Utils.listToString(images) +
        ", name: " +
        name +
        ", sku: " +
        sku +
        ", shelf: " +
        shelf;
  }

  @override
  String toString() {
    throw "not supported. use futureToString instead";
  }
}


// create mock abstract source
