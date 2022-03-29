import 'package:wms_app/models/warehouse.dart';

class WarehouseQueries {
  Warehouse _warehouse;
  WarehouseQueries(this._warehouse);

  String getProductQuery(String ean) => _warehouse.getProduct.build([ean]);
  String getProductSuggestionsQuery(String sku) =>
      _warehouse.getProductSuggestions.build([sku]);
  String findShelfQuery(String shelf) => _warehouse.findShelf.build([shelf]);
  String increaseQuantity(String productId) =>
      _warehouse.increaseQuantity.build([productId]);

  // product attributes:
  String getEANQuery(String productId) => _warehouse.getEAN.build([productId]);
  String getNameQuery(String productId) =>
      _warehouse.getName.build([productId]);
  String getShelfQuery(String productId) =>
      _warehouse.getShelf.build([productId]);
  String getSKUQuery(String productId) => _warehouse.getSKU.build([productId]);
  String getImagesQuery(String productId) =>
      _warehouse.getImages.build([productId]);
  String getQuantityQuery(String productId) =>
      _warehouse.getQuantity.build([productId]);
  String setEANQuery(String productId, String ean) =>
      _warehouse.setEAN.build([productId, ean]);
}

extension QueryExtensions on List<String> {
  String build([List<String> values = const []]) {
    var query = this.first;
    this.remove(query);

    if (this.length != values.length) {
      print(
          "error arguments passed in did not match needing arguments for the query: " +
              query);
      return "";
    }

    for (int i = 0; i < this.length; i++) {
      query.replaceAll("<$this[i]>", values[i]);
    }
    return query;
  }
}
