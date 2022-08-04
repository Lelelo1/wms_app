import 'package:wms_app/models/collectRoute.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/workStore.dart';

class CollectStore {
  static late CollectStore instance = CollectStore._();
  CollectStore._();

  CollectRoute _route = CollectRoute.empty();

  static WorkStore _workStore = WorkStore.instance;

  Future<void> collect() async {
    _workStore.clearAll();

    print("making new collect route. starting");
    _route = await _createRoute();
    print("create route completed");
    await _setCurrentProduct(_route.take());
/*
    if (_route.isEmpty) {
      
      return;
    }

    print("collect route is being collected. resuming");

    var customerProduct =
        _route.isBeingCollected ? _route.currentCustomerProduct : _route.take();
    _setCurrentProduct(customerProduct);
    */
  }

  Future<CollectRoute> _createRoute() async {
    var customerOrders =
        (await CustomerOrder.many()).where((c) => c.isChosen).take(6).toList();
    return CollectRoute(customerOrders);
  }

  Future<void> _setCurrentProduct(
      CustomerOrderProduct customerOrderProduct) async {
    print("setCurrentProduct: " + customerOrderProduct.productId);
    if (customerOrderProduct.isEmpty) {
      WorkStore.instance.currentProduct = Product.empty;
      return;
    }
    WorkStore.instance.currentProduct =
        await Product.fetchFromId(customerOrderProduct.id.toString());
    WorkStore.instance.productEvent.broadcast();
  }

  bool get isBeingCollected => _route.isBeingCollected;

  void next() {
    _setCurrentProduct(_route.take());
  }
}
