import 'package:event/event.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/utils/arg.dart';

class CollectStore {
  static late CollectStore instance = CollectStore._();
  CollectStore._();
/*
  

  static WorkStore _workStore = WorkStore.instance;

  CollectRoute _route = CollectRoute.empty();

  Future<void> collect(CustomerOrder customerOrder) async {
    _workStore.clearAll();


    await _setCurrentProduct(_route.take());
  }


// broadcast could always be in th esetter property in workstore currentproduct?
  Future<void> _setCurrentProduct(
      CustomerOrderProduct customerOrderProduct) async {
    //print("setCurrentProduct: " + customerOrderProduct.productId.toString());
    WorkStore.instance.currentProduct =
        await Product.fetchFromId(customerOrderProduct.productId);

    WorkStore.instance.productEvent.broadcast();
  }

  bool get isBeingCollected => _route.isBeingCollected;

  void next() {
    _setCurrentProduct(_route.take());
  }
*/

  Event<Arg<CustomerOrderSelectedEvent>> _selectCustomerOrderEvent =
      Event<Arg<CustomerOrderSelectedEvent>>();
  Event<Arg<CustomerOrderSelectedEvent>> get selectCustomerOrderEvent =>
      _selectCustomerOrderEvent;
}

class MyValue extends EventArgs {}
