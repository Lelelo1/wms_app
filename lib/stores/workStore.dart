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

  String currentEAN = "";

  // Be mindful when depending on multiple events in the same render hiercarchy

  Future<bool> isMatchingShelf(String shelf) async {
    var currentProduct = WorkStore.instance.currentProduct;

    if (!currentProduct.exists()) {
      WorkStore.instance.currentProduct = Product.empty();
      return false;
    }

    var productShelf = await currentProduct.getShelf();
    return shelf == productShelf;
  }

  List<String> _scanData = [];
  void addScanData(String scanData) {
    _scanData.add(scanData);
    _scanDataEvent.broadcast();
  }

  List<String> get scanData => _scanData;

  Event _scanDataEvent = Event();
  Event get scanDataEvent => _scanDataEvent;

  void clearAll() {
    this.currentProduct = Product.empty();
    this.currentEAN = "";
    this._scanData = [];
  }

  Event _assignShelfEvent = Event();
  Event get assignShelfEvent => _assignShelfEvent;
}
