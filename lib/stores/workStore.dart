import 'package:wms_app/models/product.dart';
import 'package:event/event.dart';
import 'package:wms_app/models/product.dart';

class WorkStore {
  static late WorkStore instance = WorkStore._();
  WorkStore._();

  Event<Product> _productEvent = Event<Product>();
  Event<Product> get productEvent => _productEvent;

  Product _currentProduct = Product.empty();
  Product get currentProduct => _currentProduct;
  set currentProduct(Product product) {
    _currentProduct = product;
    productEvent.broadcast(_currentProduct);
  }
}
