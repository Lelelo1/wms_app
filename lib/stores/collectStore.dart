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

  Future<CollectRoute> collect() async {
    _workStore.clearAll();

    if (_route.isEmpty) {
      print("making new collect route. starting");
      _route = await createRoute();
      setCurrentProduct(_route.take());
    }

    print("collect route is being collected. resuming");

    var customerProduct =
        _route.isBeingCollected ? _route.currentCustomerProduct : _route.take();
    setCurrentProduct(customerProduct);

    return _route;
  }

  Future<CollectRoute> createRoute() async {
    var customerOrders =
        (await CustomerOrder.many()).where((c) => c.isChosen).take(6).toList();
    return CollectRoute(customerOrders);
  }

  void setCurrentProduct(CustomerOrderProduct customerOrderProduct) async {
    if (customerOrderProduct.isEmpty) {
      WorkStore.instance.currentProduct = Product.empty;
      return;
    }
    WorkStore.instance.currentProduct =
        await Product.fetchFromId(customerOrderProduct.id.toString());
    WorkStore.instance.productEvent.broadcast();
  }

  bool get isBeingCollected => _route.isBeingCollected;
}
