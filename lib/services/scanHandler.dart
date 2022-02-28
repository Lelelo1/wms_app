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
    
    if(await isMatchingShelf(scanResult)) {
      warehouseSystem.increaseAmountOfProducts(WorkStore.instance.currentProduct);
    }

    var product = await warehouseSystem.fetchProduct(scanResult);
    if (product.exists()) {
      WorkStore.instance.currentProduct = product;
      return;
    }

    
    if(shelf)
  }

  static Future<bool> isMatchingShelf(String scanResult) async {
    
    var currentProduct = WorkStore.instance.currentProduct;

    if(!currentProduct.exists()) {
      return false;
    }
    
    var shelf = await warehouseSystem.findShelf(scanResult);
    
    if(shelf.isEmpty) {
      return false;
    }
    return shelf == await currentProduct.getShelf();
  }
}
