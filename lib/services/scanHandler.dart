import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/stores/workStore.dart';

import '../utils.dart';

typedef ProductResultHandler = void Function(Product product, String scanData);

String emptyMsg = "ignored scan. no event handler added";

class ScanHandler {
  static late WarehouseSystem warehouseSystem = WarehouseSystem.instance;
  static late VisionService visionService = VisionService.instance;

  static void scan(String filePath,
      void Function(String scanResult) scanResultCallback) async {
    // can also use ...
/*     barcode = await visionSevice.analyzeBarcodeFromBytes(
          ImageUtils.concatenatePlanes(streamImage.planes),
          ImageUtils.imageData(streamImage)); */
    if (filePath.isEmpty) {
      scanResultCallback("");
      return;
    }

    var scanResult = await visionService.analyzeBarcodeFromFilePath(filePath);
    if (scanResult.isEmpty) {
      scanResultCallback(scanResult);
      return;
    }

    scanResultCallback(scanResult);

    if (isShelf(scanResult)) {
      var handled = await handleAsShelf(scanResult.toShelf(shelfPrefix));
    }

    if (wasShelf) {
      print("waas shelf");
      return;
    }

    WorkStore.instance.currentEAN = scanResult;

    var product = await handleAsProduct(scanResult);
    if (product.exists()) {
      WorkStore.instance.currentProduct = product;
    }

    // otherwise could be wrong shelf or other qr
  }

  static Future<bool> handleAsShelf(String scanResult) async {
    print("handle as shelf");
    if (await isMatchingShelf(scanResult)) {
      warehouseSystem
          .increaseAmountOfProducts(WorkStore.instance.currentProduct);
      print("was matching shelf!");
      WorkStore.instance.currentProduct = Product.empty();
      return true;
    }
    return false;
  }

// remake!

  static Future<Product> handleAsProduct(String scanResult) async {
    var product = await warehouseSystem.fetchProduct(scanResult);
    return product;
  }
}
