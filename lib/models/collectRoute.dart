import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';


// code for scanning in collect

/*class CollectRoute {
  CustomerOrder _customerOrder = CustomerOrder.createEmpty();

  Iterator<CustomerOrderProduct> _route =
      List<CustomerOrderProduct>.empty().iterator;

  CollectRoute(this._customerOrders) {
    var customerProducts =
        _customerOrders.map((e) => e.customerOrderProducts).expand((e) => e);

    print("products to be collected: ");
    customerProducts.forEach((e) {
      print(e.productId.toString());
    });

    _route = customerProducts.iterator;
  }

  CollectRoute.empty();

  bool get isEmpty => _customerOrders.isEmpty;

  int index = 0;

  CustomerOrderProduct take() {
    var hasNext = _route.moveNext();
    isBeingCollected = hasNext;
    if (!hasNext) {
      return CustomerOrderProduct.empty();
    }
    index++;
    return _route.current;
  }

  CustomerOrderProduct get currentCustomerProduct => _route.current;

  bool isBeingCollected = false;
}
*/
