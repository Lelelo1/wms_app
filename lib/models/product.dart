// having objects tied directly to warehousesystem/database
/*
import 'package:flutter_test/flutter_test.dart';
import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/stores/workStore.dart';
import '../utils.dart';

import '../utils/default.dart';
import '../warehouseSystem/wsSqlQuery.dart';
import '../warehouseSystem/wsInteract.dart';
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
    var eanHits = await WSInteract.remoteSql<String>(WorkStore.instance.queries
        .fetchAttribute(id.toString(), KatsumiAttributes.ean));
    return Default.firstStringDefaultTo(eanHits);
  }

  static String katsumiImages = "https://www.katsumi.se/media/catalog/product/";

  @override
  Future<List<String>> getImages() async {
    var imgs = await WSInteract.remoteSql<String>(WorkStore.instance.queries
        .fetchAttribute(id.toString(), KatsumiAttributes.images));
    // potentially specify a fallback image, error image eg.
    return imgs.map((e) => katsumiImages + e).toList();
  }

  @override
  Future<String> getName() async {
    var nameHits = await WSInteract.remoteSql<String>(WorkStore.instance.queries
        .fetchAttribute(id.toString(), KatsumiAttributes.name));

    return Default.firstStringDefaultTo(nameHits, "-");
  }

  @override
  Future<String> getSKU() async {
    var skuHits = await WSInteract.remoteSql<String>(WorkStore.instance.queries
        .fetchAttribute(id.toString(), KatsumiAttributes.sku));
    return Default.firstStringDefaultTo(skuHits, "-");
  }

  @override
  Future<String> getShelf() async {
    var shelfHits = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries
        .fetchAttribute(id.toString(), KatsumiAttributes.shelf));

    return Default.firstStringDefaultTo(shelfHits, "-");
  }

  @override
  Future<double> getQuanity() async {
    var quantityHits = await WSInteract.remoteSql<double>(
        WorkStore.instance.queries.quantity(id.toString()));
    return Default.firstDoubleDefaultTo(quantityHits);
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

  static Product oneFromIds(List<int> ids) {
    if (ids.isEmpty) {
      return Product.empty();
    }

    return Product(ids.last);
  }

  static List<Product> manyFromIds(List<int> ids) {
    return ids.map((e) => Product(e)).toList();
  }
}
*/

import 'package:wms_app/warehouseSystem/wsInteract.dart';

class Product {
  Map<String, dynamic> _attributes;
  Product._(this._attributes);

  int get id => _attributes["entity_id"];

  static String katsumiProductImagesBaseUrl =
      "https://www.katsumi.se/media/catalog/product/";
  List<String> get images => (_attributes["image"] as List<String>)
      .map((e) => katsumiProductImagesBaseUrl + e)
      .toList();

  static Future<List<Product>> fetch() async {
    var models = await WSInteract.remoteSql("");

    return models.map((attributes) => Product._(attributes)).toList();
  }

  static Product empty() {
    var emptyAttributes = {"entity_id": "", "images": []};
    return Product._(emptyAttributes);
  }
}
