import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/stores/workStore.dart';

import '../utils.dart';

typedef ProductResultHandler = void Function(Product product, String scanData);

typedef Scan = Function(String scan, bool successfull);

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

    var shelf = await warehouseSystem.findShelf(scanResult);
    bool wasShelf = await handleAsShelf(shelf);
    if (wasShelf) {
      WorkStore.instance.currentProduct = Product.empty();
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
    if (await isMatchingShelf(scanResult)) {
      warehouseSystem
          .increaseAmountOfProducts(WorkStore.instance.currentProduct);
      WorkStore.instance.currentProduct = Product.empty();
      return true;
    }
    return false;
  }

// remake!
  static Future<bool> isMatchingShelf(String shelf) async {
    var currentProduct = WorkStore.instance.currentProduct;

    if (!currentProduct.exists()) {
      return false;
    }

    var productEAN = await currentProduct.getEAN();

    if (productEAN.isEmpty) {
      return false;
    }

    var productShelf = await currentProduct.getShelf();

    return shelf == productShelf;
  }

  static Future<Product> handleAsProduct(String scanResult) async {
    var product = await warehouseSystem.fetchProduct(scanResult);
    return product;
  }
}
