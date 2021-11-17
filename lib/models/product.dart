// having objects tied directly to warehousesystem/database

import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import '../utils.dart';
import 'package:collection/collection.dart';

// potentially remove the '?' operator so default values can used. Which I guess
// is the reason for the null safety anyway

class Product extends AbstractProduct {
  static final _warehouseSystem = WorkStore.instance;

  int id = 0;
  Product(int id) {
    // needed explicit constuctor for some weird reason, to set 'id'
    this.id = id;
  }

  bool isEmpty() => id == 0;
  // named constructor
  // https://dart.dev/guides/language/language-tour#constructors
  Product.empty() {
    // set all fields to non default value
  }

  @override
  Future<String> getEAN() async {
    var ean = (await _warehouseSystem.attribute<String>(id, Attribute.ean))
        ?.firstOrNull;
    return Utils.defaultString(ean, "-");
  }

  static String katsumiImages = "https://www.katsumi.se/media/catalog/product/";

  @override
  Future<List<String>> getImages() async {
    var imgs = await _warehouseSystem.attribute<String>(id, Attribute.images);
    // potentially specify a fallback image, error image eg.
    return Utils.defaultImages(imgs).map((e) => katsumiImages + e).toList();
  }

  @override
  Future<String> getName() async {
    var name = (await _warehouseSystem.attribute<String>(id, Attribute.name))
        ?.firstOrNull;
    return Utils.defaultString(name, "-");
  }

  @override
  Future<String> getSKU() async {
    var sku =
        (await _warehouseSystem.attribute(id, Attribute.sku))?.firstOrNull;
    return Utils.defaultString(sku, "-");
  }

  @override
  Future<String> getShelf() async {
    var shelf = (await _warehouseSystem.attribute<String?>(id, Attribute.shelf))
        ?.firstOrNull;
    return Utils.defaultString(shelf, "-");
  }

  @override
  Future<void> setEAN(String ean) {
    // TODO: implement setEAN
    // set ean to the product in the warehousesystem
    return Future.sync(() => null);
  }
}

abstract class AbstractProduct {
  int id = 0;
  Future<String> getEAN();
  Future<String> getSKU();
  Future<String> getShelf();
  Future<String> getName();
  Future<List<String>> getImages();

  Future<void> setEAN(String ean);
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
}

// create mock abstract source
