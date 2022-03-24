import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/warehouseSystem.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';

typedef ProductResultHandler = void Function(Product product, String scanData);

String emptyMsg = "ignored scan. no event handler added";

class ScanHandler {
  static const String shelfPrefix = "shelf:";

  static late WarehouseSystem warehouseSystem = WarehouseSystem.instance;
  static late VisionService visionService = VisionService.instance;

  static void scan(String filePath) async {
    // can also use ...
/*     barcode = await visionSevice.analyzeBarcodeFromBytes(
          ImageUtils.concatenatePlanes(streamImage.planes),
          ImageUtils.imageData(streamImage)); */
    if (filePath.isEmpty) {
      return;
    }

    var scanResult = await visionService.analyzeBarcodeFromFilePath(filePath);
    if (scanResult.isEmpty) {
      return;
    }

    CameraViewController.scanningSuccessfull();

    WorkStore.instance.addScanData(scanResult);
    var lastProduct = WorkStore.instance.currentProduct;

    var product = await handleAsProduct(scanResult);
    if (product.exists()) {
      WorkStore.instance.currentProduct = product;
      print("currentProduct is : " + await product.getName());
      return;
    }

    if (!_isShelf(scanResult)) {
      WorkStore.instance.currentEAN = scanResult;
      WorkStore.instance.currentProduct = Product.empty();
      return;
    }

    var shelf = removeShelfPrefix(scanResult);
    WorkStore.instance.currentShelf = shelf;

    // hanlding case when product scanned pevisouly needs shelf assigned to it
    print("lastProduct: " + await lastProduct.futureToString());
    if (lastProduct.exists()) {
      var lastProductShelf = await lastProduct.getShelf();
      if (lastProductShelf.contains(AbstractProduct.assignShelf)) {
        WorkStore.instance.assignShelfEvent.broadcast();
        return;
      }
    }

    var match = await WorkStore.instance.isMatchingShelf(shelf);
    if (!match) {
      return;
    }

    handleAsShelf(shelf);
  }

  static void handleAsShelf(String scanResult) async {
    warehouseSystem.increaseAmountOfProducts(WorkStore.instance.currentProduct);
    WorkStore.instance.clearAll();
  }

  static Future<Product> handleAsProduct(String scanResult) async {
    var product = await warehouseSystem.fetchProduct(scanResult);
    return product;
  }

  static bool _isShelf(String scanData) {
    return scanData.contains(shelfPrefix);
  }

  static String removeShelfPrefix(String shelf) =>
      shelf.replaceAll(shelfPrefix, "");
}
