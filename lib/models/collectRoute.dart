import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';

class CollectRoute {
  List<CustomerOrder> _customerOrders = List.empty(growable: false);

  List<CustomerOrderProduct> _route = List.empty(growable: true);
  CollectRoute(this._customerOrders) {
    _route = _customerOrders
        .map((e) => e.customerOrderProducts)
        .expand((e) => e)
        .toList();
  }

  CollectRoute.empty() 
}
