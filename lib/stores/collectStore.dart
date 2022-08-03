import 'package:wms_app/models/collectRoute.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/workStore.dart';

class CollectStore {
  static late CollectStore instance = CollectStore._();
  CollectStore._();

  CollectRoute _route = CollectRoute.empty();

  CustomerOrderProduct currentCustomerOrderProduct =
      CustomerOrderProduct.empty();

  static WorkStore _workStore = WorkStore.instance;

  void collect() async {
    _workStore.clearAll();

    if (_route.isBeingCollected) {
      setCurrentProduct(_route.currentCustomerProduct);
    }

    var customerOrders =
        (await CustomerOrder.many()).where((c) => c.isChosen).take(6).toList();
    _route = CollectRoute(customerOrders);
    setCurrentProduct(_route.take());
    return;
  }

  void setCurrentProduct(CustomerOrderProduct customerOrderProduct) async {
    if (customerOrderProduct.isEmpty) {
      WorkStore.instance.currentProduct = Product.empty;
      return;
    }

    WorkStore.instance.currentProduct =
        await Product.fetchFromId(currentCustomerOrderProduct.id.toString());
  }

  bool get isBeingCollected => _route.isBeingCollected;
}
