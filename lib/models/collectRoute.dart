import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';

class CollectRoute {
  List<CustomerOrder> _customerOrders = List.empty(growable: true);

  Iterator<CustomerOrderProduct> _route =
      List<CustomerOrderProduct>.empty().iterator;

  CollectRoute(this._customerOrders) {
    _route = _customerOrders
        .map((e) => e.customerOrderProducts)
        .expand((e) => e)
        .iterator;
  }

  CollectRoute.empty();

  bool get isEmpty => _customerOrders.isEmpty;

  CustomerOrderProduct take() {
    var hasNext = _route.moveNext();
    isBeingCollected = hasNext;
    return hasNext ? _route.current : CustomerOrderProduct.empty();
  }

  CustomerOrderProduct get currentCustomerProduct => _route.current;

  bool isBeingCollected = false;
}
