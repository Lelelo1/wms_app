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

  void collect() async {
    _workStore.clearAll();
/*
    if (_route.isBeingCollected) {
      print("collect route is being collected. resuming");
      setCurrentProduct(_route.currentCustomerProduct);
    }
*/
    print("makeing new collect route. starting");
    var customerOrders =
        (await CustomerOrder.many()).where((c) => c.isChosen).take(6).toList();
    _route = CollectRoute(customerOrders);

    setCurrentProduct(_route.take());
    return;
  }

  void setCurrentProduct(CustomerOrderProduct customerOrderProduct) async {
    print("sssss: " + customerOrderProduct.id.toString());
    if (customerOrderProduct.isEmpty) {
      WorkStore.instance.currentProduct = Product.empty;
      return;
    }
    print("seeeet: " + customerOrderProduct.id.toString());
    WorkStore.instance.currentProduct =
        await Product.fetchFromId(customerOrderProduct.id.toString());
    WorkStore.instance.productEvent.broadcast();
  }

  bool get isBeingCollected => _route.isBeingCollected;
}
