// having objects tied directly to warehousesystem/database

import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';

import '../utils.dart';

class Product extends AbstractProduct {
  static final _warehouseSystem = AppStore.injector.get<WorkStore>();

  int id;
  Product(int id) {
    // needed explicit constuctor for some weird reason, to set 'id'
    this.id = id;
  }

  @override
  Future<String> getEAN() async {
    var ean = (await _warehouseSystem.attribute(id, Attribute.ean)).first;
    return Utils.defaultToDash(ean);
  }

  static String katsumiImages = "https://www.katsumi.se/media/catalog/product/";
  @override
  Future<List<String>> getImages() async {
    var imgs = await _warehouseSystem.attribute<String>(id, Attribute.image);
    return imgs.map((e) => katsumiImages + e).toList();
  }

  @override
  Future<String> getName() async {
    return Utils.defaultToDash(
        (await _warehouseSystem.attribute<String>(id, Attribute.name)).first);
  }

  @override
  Future<String> getSKU() async {
    var sku = (await _warehouseSystem.attribute(id, Attribute.sku)).first;
    return Utils.defaultToDash(sku);
  }

  @override
  Future<String> getShelf() async {
    return Utils.defaultToDash(
        (await _warehouseSystem.attribute<String>(id, Attribute.shelf)).first);
  }

  @override
  Future<void> setEAN(String ean) {
    // TODO: implement setEAN
    // set ean to the product in the warehousesystem
  }
}

abstract class AbstractProduct {
  int id;
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
