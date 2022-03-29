import 'package:wms_app/models/warehouse.dart';

typedef Query = String;

class WarehouseQueries {
  static late WarehouseQueries instance;
  Warehouse _warehouse;
  WarehouseQueries._(this._warehouse);

  Query getProductQuery(String ean) => _warehouse.getProduct.build([ean]);
  Query getProductSuggestionsQuery(String sku) =>
      _warehouse.getProductSuggestions.build([sku]);
  Query findShelfQuery(String shelf) => _warehouse.findShelf.build([shelf]);
  Query increaseQuantity(String productId) =>
      _warehouse.increaseQuantity.build([productId]);

  // product attributes:
  Query getEANQuery(String productId) => _warehouse.getEAN.build([productId]);
  Query getNameQuery(String productId) => _warehouse.getName.build([productId]);
  Query getShelfQuery(String productId) =>
      _warehouse.getShelf.build([productId]);
  Query getSKUQuery(String productId) => _warehouse.getSKU.build([productId]);
  Query getImagesQuery(String productId) =>
      _warehouse.getImages.build([productId]);
  Query getQuantityQuery(String productId) =>
      _warehouse.getQuantity.build([productId]);
  Query setEANQuery(String productId, String ean) =>
      _warehouse.setEAN.build([productId, ean]);
}

extension QueryExtensions on List<String> {
  Query build([List<String> values = const []]) {
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
