import 'package:camera/camera.dart';
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
  
    var product = await asProduct(scanResult);
    if(product.exists()) {

    }
  }

  static Future<Product> asProduct(String scanResult) async {
    return  await warehouseSystem.fetchProduct(scanData);
  }

  static void asShelf(String scanResult) async {
    var shelf = await warehouseSystem.findShelf(scanResult);
    if (shelf.isEmpty) {
      return;
    }

  }

  static void handleScanData(String scanData, Product currentlyScannedProduct,
      ProductResultHandler productResultHandler) async {
    var product = 
    if (product.exists()) {}
  }

  static void increaseAmountProductExistsMatchingShelf(
      String shelf) async {
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
    onQR(shelf, true);
  }
}
