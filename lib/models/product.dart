// having objects tied directly to warehousesystem/database

import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';

class Product extends AbstractProduct {
  static final _warehouseSystem = AppStore.injector.get<WorkStore>();

  int id;
  Product(int id);

  @override
  Future<String> getEAN() {
    // TODO: implement getEAN
    throw UnimplementedError();
  }

  @override
  Future<String> getImage() {
    // TODO: implement getImage
    throw UnimplementedError();
  }

  @override
  Future<String> getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  Future<String> getSKU() {
    // TODO: implement getSKU
    throw UnimplementedError();
  }

  @override
  Future<String> getShelf() {
    print("getting shelf");
    return _warehouseSystem.attribute(id, Attribute.c2c_hyllplats);
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
  Future<String> getImage();

  Future<void> setEAN(String ean);
}

class MockProduct implements AbstractProduct {
  @override
  int id;

  MockProduct(
      this.id, this._ean, this._img, this._name, this._sku, this._shelf);

  String _ean;
  String _img;
  String _name;
  String _sku;
  String _shelf;

  @override
  Future<String> getEAN() => Future.sync(() => _ean);

  @override
  Future<String> getImage() => Future.sync(() => _img);

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
