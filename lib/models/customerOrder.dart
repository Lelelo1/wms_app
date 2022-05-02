import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';

class CustomerOrder {
  final int id;
  CustomerOrder(this.id);

  Future<String> _getCustomerFirstName() async {
    var r = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries.customerOrders
        .getCustomerFirstName(id.toString()));

    if (r.isEmpty) {
      return "-";
    }

    return Default.firstStringDefaultTo(r);
  }

  Future<String> _getCustomerLastName() async {
    var r = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries.customerOrders
        .getCustomerLastName(id.toString()));

    return Default.firstStringDefaultTo(r, "-");
  }

  Future<String> getCustomerName() {
    return Future.sync(() async {
      var firstName = await _getCustomerFirstName();
      var lastName = await _getCustomerLastName();

      return firstName + " " + lastName;
    });
  }

  Future<List<int>> getProducts() async {
    var r = await WSInteract.remoteSql<int>(
        WorkStore.instance.queries.customerOrders.getProducts(id.toString()));
    return r;
  }

  Future<String> getIncrementId() async {
    var r = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries.customerOrders
        .getIncrementId(id.toString()));
    print("r is : " + r.toString());
    return Default.firstStringDefaultTo(r);
  }
}
