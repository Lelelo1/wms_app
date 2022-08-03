import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';

class CollectRoute {
  List<CustomerOrder> _customerOrders = List.empty(growable: true);

  List<CustomerOrderProduct> _route = List.empty(growable: true);
  CollectRoute(this._customerOrders) {
    _route = _customerOrders
        .map((e) => e.customerOrderProducts)
        .expand((e) => e)
        .toList();
  }

  CollectRoute.empty();

  bool get isEmpty => _customerOrders.isEmpty && _route.isEmpty;

  CustomerOrderProduct take() {
    var hasNext = _route.iterator.moveNext();

    isBeingCollected = hasNext;

    return hasNext ? _route.iterator.current : CustomerOrderProduct.empty();
  }

  CustomerOrderProduct get currentCustomerProduct => _route.iterator.current;

  bool isBeingCollected = false;
}
