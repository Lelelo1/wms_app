import 'package:wms_app/models/abstractProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/warehouseSystem/wsSqlQuery.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';

typedef ProductResultHandler = void Function(Product product, String scanData);

String emptyMsg = "ignored scan. no event handler added";

class ScanHandler {
  static const String shelfPrefix = "shelf:";

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

    handleScanResult(scanResult);
  }

  static void handleScanResult(String scanResult) async {
    WorkStore.instance.addScanData(scanResult);
    var lastProduct = WorkStore.instance.currentProduct;

    var product = await _handleAsProduct(scanResult);
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
    print("is matching shelf: " + match.toString());
    if (!match) {
      return;
    }

    _handleAsShelf(shelf);
  }

  static void _handleAsShelf(String scanResult) async {
    WorkStore.instance.queries
        .increaseAmountOfProduct(
            WorkStore.instance.currentProduct.id.toString())
        .forEach((sqlStatement) async {
      print(sqlStatement);
      await WSInteract.remoteSql(sqlStatement);
    });
    WorkStore.instance.clearAll();
  }

  static Future<Product> _handleAsProduct(String scanResult) async {
    var productIds = await WSInteract.remoteSql<int>(
        WorkStore.instance.queries.fetchProduct(scanResult));
    var product = Product.oneFromIds(productIds.toList());
    return product;
  }

  static bool _isShelf(String scanData) {
    return scanData.contains(shelfPrefix);
  }

  static String removeShelfPrefix(String shelf) =>
      shelf.replaceAll(shelfPrefix, "");
}
