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
    if (!product.exists()) {
      currentEAN = "";
    }
    productEvent.broadcast();
  }

  String currentEAN = "";

  // Be mindful when depending on multiple events in the same render hiercarchy

  Future<bool> isMatchingShelf(String shelf) async {
    var currentProduct = WorkStore.instance.currentProduct;

    if (!currentProduct.exists()) {
      print("product don't exist!");
      WorkStore.instance.currentProduct = Product.empty();
      return false;
    }

    var productShelf = await currentProduct.getShelf();
    print(productShelf + " izz " + shelf);
    return shelf == productShelf;
  }
}
