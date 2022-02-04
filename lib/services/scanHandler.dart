import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/stores/workStore.dart';

class ScanHandler {
  static late WarehouseSystem warehouseSystem = WarehouseSystem.instance;

  static void handleScanData(String scanData, Product currentlyScannedProduct,
      Function(Product product) barcodeHandler) async {
    if (await _didScanQR(scanData)) {
      print("was qr");
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

  static Future<bool> _didScanQR(String scanData) async {
    var shelfMatch = await warehouseSystem.findShelf(scanData);
    return scanData == shelfMatch;
  }
}
