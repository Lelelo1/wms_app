// having objects tied directly to warehousesystem/database

import 'package:event/event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/stores/workStore.dart';
import '../utils.dart';
import 'package:collection/collection.dart';

// potentially remove the '?' operator so default values can used. Which I guess
// is the reason for the null safety anyway

class Product extends AbstractProduct {
  Product(int id) : super(id);

  Product.empty() : super.empty();

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
    var s = Utils.defaultString(shelf, "-");
    if (s == "-") {
      return s;
    }

    return AbstractProduct.shelfPrefix + s;
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

abstract class AbstractProduct extends EventArgs {
  final int id;
  Future<String> getEAN();
  Future<String> getSKU();
  Future<String> getShelf();
  Future<double> getQuanity();
  Future<String> getName();
  Future<List<String>> getImages();

  Future<void> setEAN(String ean);

  AbstractProduct(this.id);
  AbstractProduct.empty([this.id = 0]);

  static const String shelfPrefix = "shelf:";

  static const assignShelf = "S-3-1"; //"BEST";
}

class MockProduct implements AbstractProduct {
  @override
  int id;

  MockProduct(
      this.id, this._ean, this._imgs, this._name, this._sku, this._shelf);

  String _ean;
  List<String> _imgs;
  String _name;
  String _sku;
  String _shelf;

  @override
  Future<String> getEAN() => Future.sync(() => _ean);

  @override
  Future<List<String>> getImages() => Future.sync(() => _imgs);

  @override
  Future<String> getName() => Future.sync(() => _name);

  @override
  Future<String> getSKU() => Future.sync(() => _sku);

  @override
  Future<String> getShelf() => Future.sync(() => _shelf);

  @override
  Future<void> setEAN(String ean) {
    this._ean = ean;
    return Future.sync(() => null);
  }

  @override
  Future<double> getQuanity() {
    // TODO: implement getQuanity
    throw UnimplementedError();
  }
}

// create mock abstract source
