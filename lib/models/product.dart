// having objects tied directly to warehousesystem/database

import 'package:flutter_test/flutter_test.dart';
import 'package:wms_app/models/attributes.dart';
import '../utils.dart';

import '../warehouseSystem/sqlQuery.dart';
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
    var eanHits = await Connect.remoteSql<String>(
        SQLQuery.fetchAttribute(id.toString(), Attributes.ean));
    return firstStringDefaultTo(eanHits);
  }

  static String katsumiImages = "https://www.katsumi.se/media/catalog/product/";

  @override
  Future<List<String>> getImages() async {
    var imgs = await Connect.remoteSql<String>(
        SQLQuery.fetchAttribute(id.toString(), Attributes.images));
    // potentially specify a fallback image, error image eg.
    return imgs.map((e) => katsumiImages + e).toList();
  }

  @override
  Future<String> getName() async {
    var nameHits = await Connect.remoteSql<String>(
        SQLQuery.fetchAttribute(id.toString(), Attributes.name));

    return firstStringDefaultTo(nameHits, "-");
  }

  @override
  Future<String> getSKU() async {
    var skuHits = await Connect.remoteSql<String>(
        SQLQuery.fetchAttribute(id.toString(), Attributes.sku));
    return firstStringDefaultTo(skuHits, "-");
  }

  @override
  Future<String> getShelf() async {
    var shelfHits = await Connect.remoteSql<String>(
        SQLQuery.fetchAttribute(id.toString(), Attributes.shelf));

    return firstStringDefaultTo(shelfHits, "-");
  }

  @override
  Future<double> getQuanity() async {
    var quantityHits =
        await Connect.remoteSql<double>(SQLQuery.quantity(id.toString()));
    return firstDoubleDefaultTo(quantityHits);
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


// create mock abstract source
