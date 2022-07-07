import 'package:flutter/widgets.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/warehouseSystem/wsSqlQuery.dart';
import '../types.dart';

class Product {
  Map<String, dynamic> _attributes = _empty;
  Product._(this._attributes);

  int get id => int.parse(Utils.getAndDefaultAs(_attributes["@id"], "0"));

  int get ean => int.parse(Utils.getAndDefaultAs(_attributes["@ean"], "0"));

  String get name => Utils.getAndDefaultAs(_attributes["@name"], "");

  String get shelf => Utils.getAndDefaultAs(_attributes["@shelf"], "");

  String get sku => Utils.getAndDefaultAs(_attributes["@sku"], "");

// SELECT @id, @ean, @name, @shelf, @sku, @image_front, @image_back, @qty;
  String get frontImage =>
      toKatsumiImage(Utils.getAndDefaultAs(_attributes["@image_front"], ""));

  String get backImage =>
      toKatsumiImage(Utils.getAndDefaultAs(_attributes["@image_back"], ""));

  String toKatsumiImage(String? image) {
    if (Utils.isNullOrEmpty(image)) {
      return "";
    }

    return "https://www.katsumi.se/media/catalog/product/" + (image as String);
  }

  double get qty =>
      double.parse(Utils.getAndDefaultAs(_attributes["@qty"], "0"));

  bool get exists => id != 0;

  static Future<Product> fetchFromId(String id) async {
    var models = await WSInteract.remoteSql(ProductQueries.fromId(id));
    return _firstOrEmpty(models);
  }

  static Future<Product> fetchFromEAN(String ean) async {
    var eanQuery = ProductQueries.fromEAN(ean);
    var models = await WSInteract.remoteSql(eanQuery);
    return _firstOrEmpty(models);
  }

  static Future<List<Product>> fetchSuggestionsFromSkuText(
      String skuText) async {
    var models =
        await WSInteract.remoteSql(ProductQueries.fromSkuText(skuText));

    return await Future.wait(
        models.map((e) => Product.fetchFromId(e.values.first as String)));
  }

  static Product get empty => Product._(_empty);

  // SELECT @id, @ean, @name, @shelf, @sku, @image_front, @image_back, @qty;
  static Model get _empty => {
        "@id": null,
        "@ean": null,
        "@name": null,
        "@shelf": null,
        "@sku": null,
        "@image_front": null,
        "@image_back": null,
        "@qty": null
      };

  static Product _firstOrEmpty(Iterable<Model> models) {
    if (models.isEmpty) {
      return empty;
    }

    return models.map((attributes) => Product._(attributes)).first;
  }

  @override
  String toString() {
    return _attributes.toString();
  }
}
