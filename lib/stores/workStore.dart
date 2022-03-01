import 'package:wms_app/models/product.dart';
import 'package:event/event.dart';
import 'package:wms_app/models/product.dart';

class WorkStore {
  static late WorkStore instance = WorkStore._();
  WorkStore._();

  // can use 'EventArgs' since it required nullable object
  Event _productEvent = Event();
  Event get productEvent => _productEvent;

  Product _currentProduct = Product.empty();
  Product get currentProduct => _currentProduct;
  set currentProduct(Product product) {
    _currentProduct = product;
    productEvent.broadcast();
  }

  Event scanResultEvent = Event();
  String _currentScanResult = "";
  String get currentScanResult => _currentScanResult;
  set currentScanResult(String scanResult) {
    _currentScanResult = scanResult;
    scanResultEvent.broadcast();
  }
}
