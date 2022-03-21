import 'dart:ffi';

import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/WarehouseSystem.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';

import '../utils.dart';

typedef ProductResultHandler = void Function(Product product, String scanData);

String emptyMsg = "ignored scan. no event handler added";

class ScanHandler {
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

    var product = await handleAsProduct(scanResult);
    if (product.exists()) {
      WorkStore.instance.currentProduct = product;
      return;
    }

    if (!_isShelf(scanResult)) {
      WorkStore.instance.currentEAN = scanResult;
      WorkStore.instance.currentProduct = Product.empty();
      return;
    }

    var match = await WorkStore.instance.isMatchingShelf(scanResult);
    if (!match) {
      return;
    }

    handleAsShelf(scanResult);
  }

  static void handleAsShelf(String scanResult) async {
    warehouseSystem.increaseAmountOfProducts(WorkStore.instance.currentProduct);
    WorkStore.instance.currentProduct = Product.empty();
  }

  static Future<Product> handleAsProduct(String scanResult) async {
    var product = await warehouseSystem.fetchProduct(scanResult);
    return product;
  }

  static final String shelfPrefix = "shelf:";

  static bool _isShelf(String scanData) {
    return scanData.contains(shelfPrefix);
  }
}
