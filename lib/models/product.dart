import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/warehouseSystem/wsSqlQuery.dart';
import '../types.dart';

class Product {
  Map<String, dynamic> _attributes = _empty;
  Product._(this._attributes);

  bool get isEmpty => id == 0;

  int get id => int.parse(Utils.getAndDefaultAs(_attributes["id"], "0"));

  String get ean => Utils.getAndDefaultAs(_attributes["ean"], "");
  void mockSetEAN(String mockEAN) {
    _attributes["ean"] = mockEAN;
  }

  Future<Product> setEAN(String ean) async {
    await WSInteract.remoteSql(
        ProductQueries.setEAN(id.toString(), ean.toString()));
    return fetchFromId(id);
  }

  String get name => Utils.getAndDefaultAs(_attributes["name"], "");

  String get shelf => Utils.getAndDefaultAs(_attributes["shelf"], "");
  Future<void> setShelf(String shelf) async {
    await WSInteract.remoteSql(ProductQueries.setShelf(id.toString(), shelf));
  }

  String get sku => Utils.getAndDefaultAs(_attributes["sku"], "");

// SELECT @id, @ean, @name, @shelf, @sku, @image_front, @image_back, @qty;
  String get frontImage =>
      toKatsumiImage(Utils.getAndDefaultAs(_attributes["image_front"], ""));

  String get backImage =>
      toKatsumiImage(Utils.getAndDefaultAs(_attributes["image_back"], ""));

  String toKatsumiImage(String? image) {
    if (Utils.isNullOrEmpty(image)) {
      return "";
    }

    return "https://www.katsumi.se/media/catalog/product/" + (image as String);
  }

  double get qty =>
      double.parse(Utils.getAndDefaultAs(_attributes["qty"], "0"));
  Future<void> increaseQty() async {
    await WSInteract.remoteSql(ProductQueries.increaseQty(id.toString()));
  }

  static Future<Product> fetchFromId(int id) async {
    if (id == 0) {
      return Product.createEmpty;
    }
    var models =
        await WSInteract.remoteSql(ProductQueries.fromId(id.toString()));
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
        models.map((e) => Product.fetchFromId(e.values.first as int)));
  }

  static Product get createEmpty => Product._(_empty);

  // SELECT @id, @ean, @name, @shelf, @sku, @image_front, @image_back, @qty;
  static Model get _empty => {
        "id": null,
        "ean": null,
        "name": null,
        "shelf": null,
        "sku": null,
        "image_front": null,
        "image_back": null,
        "qty": null
      };

  static Product _firstOrEmpty(Iterable<Model> models) {
    if (models.isEmpty) {
      return createEmpty;
    }

    return models.map((attributes) => Product._(attributes)).first;
  }

  Future<void> update() async {
    WorkStore.instance.currentProduct = await Product.fetchFromId(id);
  }

  @override
  String toString() {
    return _attributes.toString();
  }
}
