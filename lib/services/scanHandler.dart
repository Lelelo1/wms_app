import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/stores/workStore.dart';

class ScanHandler {
  static late WarehouseSystem warehouseSystem = WarehouseSystem.instance;

  static Future<Product> handleScanData(String scanData,
      [Product currentlyScannedProduct = const Product.empty()]) async {
    if (await didScanQR(scanData)) {
      if (currentlyScannedProduct.exists()) {
        warehouseSystem.incrimentAmountOfProducts(currentlyScannedProduct);
      } else {
        // scanned a shelf without having a scanned product
      }
      return Future.sync(() => Product.empty());
    }

    return warehouseSystem.fetchProduct(scanData);
  }

  static Future<bool> didScanQR(String scanData) async {
    var shelfMatch = await warehouseSystem.findShelf(scanData);
    return scanData == shelfMatch;
  }
}
