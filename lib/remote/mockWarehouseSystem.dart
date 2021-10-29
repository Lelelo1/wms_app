import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/abstractWarehouseSystem.dart';

class MockWarehouseSystem implements AbstractWarehouseSystem {
  @override
  Future<MockProduct> getProduct(String ean) => Future.sync(() => MockProduct(
      111111111,
      "eaneaneanean",
      "assets/images/product_placeholder.png",
      "1productnameproduct",
      "1skuskuskusku",
      "1Shelf-11-2"));

  @override
  Future<List<AbstractProduct>> getProducts() => Future.sync(() => [
        MockProduct(
            111111111,
            "eaneaneanean",
            "assets/images/product_placeholder.png",
            "1productnameproduct",
            "1skuskuskusku",
            "1Shelf-11-2"),
        MockProduct(
            222222222,
            "eaneaneanean",
            "assets/images/product_placeholder.png",
            "2productnameproduct",
            "2skuskuskusku",
            "2Shelf-11-2"),
        MockProduct(
            333333333,
            "eaneaneanean",
            "assets/images/product_placeholder.png",
            "3productnameproduct",
            "3skuskuskusku",
            "3Shelf-11-2"),
        MockProduct(
            444444444,
            "eaneaneanean",
            "assets/images/product_placeholder.png",
            "4productnameproduct",
            "4skuskuskusku",
            "4Shelf-11-2"),
        MockProduct(
            5555555555,
            "eaneaneanean",
            "assets/images/product_placeholder.png",
            "5productnameproduct",
            "5skuskuskusku",
            "5Shelf-11-2"),
        MockProduct(
            666666666,
            "eaneaneanean",
            "assets/images/product_placeholder.png",
            "6productnameproduct",
            "6skuskuskusku",
            "6Shelf-11-2"),
        MockProduct(
            7777777777,
            "eaneaneanean",
            "assets/images/product_placeholder.png",
            "7productnameproduct",
            "7skuskuskusku",
            "7Shelf-11-2"),
        MockProduct(
            8888888888,
            "eaneaneanean",
            "assets/images/product_placeholder.png",
            "8productnameproduct",
            "8skuskuskusku",
            "8Shelf-11-2")
      ]);

  @override
  Future<List<String>> getSKUSuggestions(String text) => Future.sync(() => [
        "1skuSuugestion",
        "2skuSuugestion",
        "3skuSuugestion",
        "4skuSuugestion",
        "5skuSuugestion",
        "6skuSuugestion",
        "7skuSuugestion",
        "8skuSuugestion",
        "9skuSuugestion"
      ]);

  @override
  Future<T> attribute<T>(int id, Attribute attribute) {
    // TODO: implement attribute
    throw UnimplementedError();
  }

  @override
  Future<AbstractProduct> product(String ean) {
    // TODO: implement product
    throw UnimplementedError();
  }

  @override
  Future<List<AbstractProduct>> products() {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<List<String>> skuSuggestions(String text) {
    // TODO: implement skuSuggestions
    throw UnimplementedError();
  }
}
