import 'package:wms_app/models/abstractProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';

typedef ProductResultHandler = void Function(Product product, String scanData);

String emptyMsg = "ignored scan. no event handler added";

class ScanHandler {
  static const String shelfPrefix = "shelf:";

  static late VisionService visionService = VisionService.instance;

  static Future<String> scan(String filePath) async {
    // can also use ...
/*     barcode = await visionSevice.analyzeBarcodeFromBytes(
          ImageUtils.concatenatePlanes(streamImage.planes),
          ImageUtils.imageData(streamImage)); */
    if (filePath.isEmpty) {
      return "";
    }

    return await visionService.analyzeBarcodeFromFilePath(filePath);
  }

  static void handleAsBarcode(String scanResult) async {
    CameraViewController.scanningSuccessfull();

    WorkStore.instance.addScanData(scanResult);
    var lastProduct = WorkStore.instance.currentProduct;

    var product = await Product.fetchFromEAN(scanResult);
    if (!product.isEmpty) {
      WorkStore.instance.currentProduct = product;
      return;
    }

    WorkStore.instance.currentEAN = scanResult;
    WorkStore.instance.currentProduct = Product.createEmpty;

    var shelf = removeShelfPrefix(scanResult);
    WorkStore.instance.currentShelf = shelf;

    // hanlding case when product scanned pevisouly needs shelf assigned to it
    print("lastProduct: " + lastProduct.toString());
    if (!lastProduct.isEmpty) {
      var lastProductShelf = lastProduct.shelf;
      if (lastProductShelf.contains(AbstractProduct.assignShelf)) {
        WorkStore.instance.assignShelfEvent.broadcast();
        return;
      }
    }
    // should be defined by the module what happens after a scan shelf with product
    //WorkStore.instance.clearAll();
  }

  static Future<void> handleAsShelf(String scanResult) async {
    var match = await WorkStore.instance.isMatchingShelf(scanResult);
    //print("is matching shelf: " + match.toString());
    if (!match) {
      return;
    }

    // scanned shelf with a product
    WorkStore.instance.currentProduct.increaseQty();
  }

  static bool isShelf(String scanData) {
    return scanData.contains(shelfPrefix);
  }

  static String removeShelfPrefix(String shelf) =>
      shelf.replaceAll(shelfPrefix, "");
}
