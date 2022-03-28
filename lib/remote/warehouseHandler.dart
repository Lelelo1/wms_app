import 'package:wms_app/models/warehouse.dart';

class WarehouseQueries {
  Warehouse _warehouse;
  WarehouseQueries(this._warehouse);

  String getProductQuery(String ean) =>
      _warehouse.getProduct.first.replaceAll("<$ean>", ean);
}
