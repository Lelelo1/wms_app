class Product {
  Map<String, dynamic> _attributes;
  Product._(this._attributes);

  int get id => _attributes["entity_id"];
  int get ean => _attributes["ean_code"];

  static String katsumiImages = "https://www.katsumi.se/media/catalog/product/";

  List<String> get images => (_attributes["images"] as List<String>)
      .map((e) => katsumiImages + e)
      .toList();
  String get name => _attributes["name"];

  String get sku => _attributes["sku"];
  String get shelf => _attributes["c2c_hyllplats"];

  int get quantity => _attributes["qty"];

  static _fetchQuery(int ean) => ""
  static Future<Product> fetch(int ean) {

  }
}
