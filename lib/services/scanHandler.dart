import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/stores/workStore.dart';

import '../utils.dart';

class ScanHandler {
  static late WarehouseSystem warehouseSystem = WarehouseSystem.instance;

  static void handleScanData(String scanData, Product currentlyScannedProduct,
      Function(Product product) barcodeHandler) async {
    var asShelf = await _toQR(scanData);
    if (asShelf.isNotEmpty) {
      print("was qr: " + asShelf);
      if (currentlyScannedProduct.exists()) {
        print("increasing product amount");
        warehouseSystem.increaseAmountOfProducts(currentlyScannedProduct);
      } else {
        // scanned a shelf without having a scanned product
      }

      return;
    }

    barcodeHandler(await warehouseSystem.fetchProduct(scanData));
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
}
