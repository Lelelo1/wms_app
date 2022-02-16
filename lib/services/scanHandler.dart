import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/stores/workStore.dart';

import '../utils.dart';

typedef ProductResultHandler = void Function(Product product, String scanData);

class ScanHandler {
  static late WarehouseSystem warehouseSystem = WarehouseSystem.instance;

  static void handleScanData(String scanData, Product currentlyScannedProduct,
      ProductResultHandler productResultHandler) async {
    var asShelf = await _toQR(scanData);

    if (asShelf.isNotEmpty) {
      print("was qr: " + asShelf);
      increaseAmountProductExistsMatchingShelf(
          asShelf, currentlyScannedProduct, productResultHandler);
      return;
    }

    productResultHandler(
        await warehouseSystem.fetchProduct(scanData), scanData);
  }

  static Future<String> _toQR(String scanData) async {
    try {
      // removal of 'http://' part in wr code
      var possibleShelf = scanData.split("//")[1];
      var shelf = await warehouseSystem.findShelf(possibleShelf);
      return shelf;
    } catch (exc) {
      return "";
    }
  }

  static void increaseAmountProductExistsMatchingShelf(String shelf,
      Product product, ProductResultHandler productResultHandler) async {
    if (!product.exists()) {
      return;
    }
    var productShelf = await product.getShelf();

    var isMatchingShelf = shelf == productShelf;
    if (!isMatchingShelf) {
      // signal wrong shelf to user...?
      return;
    }
    print("increasing product amount");
    warehouseSystem.increaseAmountOfProducts(product);

    // reset remove current from ui/unselect
    productResultHandler(Product.empty(), "");
  }
}
