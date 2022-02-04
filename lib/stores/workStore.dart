
// seems like ui can talk directly to warehousesystem now

/*
import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/warehouseSystem.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsPage.dart';

class WorkStore {
  static late WorkStore instance = WorkStore.instance;

  WorkStore._();

  // how to interact with ui error message?

  Future<Product> fetchProduct(String ean) =>
      WarehouseSystem.fetchProduct(ean);

  Future<List<Product>> fetchSuggestions(String text) async =>
      _warehouseSystem.fetchSuggestions(text);

  Future<List<T>?> attribute<T>(int id, String attribute) =>
      _warehouseSystem.fetchAttribute<T>(id, attribute);

  void setEAN(int id, String ean) => _warehouseSystem.setEAN(id, ean);

  //String scannedBarcode = "";

/*
  Sequence getRegistration() {
    return null;
  }

  Sequence getCounting() {
    return null;
  }
  */
}
*/