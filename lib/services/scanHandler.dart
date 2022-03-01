import 'package:camera/camera.dart';
import 'package:event/event.dart';
import 'package:flutter/material.dart';
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

    bool wasShelf = await handleAsShelf(scanResult);
    if (wasShelf) {
      return;
    }

    WorkStore.instance.currentEAN = scanResult;

    var product = await handleAsProduct(scanResult);
    WorkStore.instance.currentProduct = product;
    // need to signal to pages th eresult and status for pages like return
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

  static Future<bool> isMatchingShelf(String scanResult) async {
    var currentProduct = WorkStore.instance.currentProduct;

    if (!currentProduct.exists()) {
      return false;
    }

    var shelf = await warehouseSystem.findShelf(scanResult);

    if (shelf.isEmpty) {
      return false;
    }
    return shelf == await currentProduct.getShelf();
  }

  static Future<Product> handleAsProduct(String scanResult) async {
    var product = await warehouseSystem.fetchProduct(scanResult);
    return product;
  }
}
