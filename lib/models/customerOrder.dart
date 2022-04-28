import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';

class CustomerOrder {
  final int id;
  CustomerOrder(this.id);

  Future<String> getCustomerName() async {
    var r = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries.customerOrders
        .getCustomerName(id.toString()));

    if (r.isEmpty) {
      return "-";
    }

    return Default.firstStringDefaultTo(r);
  }

  Future<List<int>> getProducts() async {
    var r = await WSInteract.remoteSql<int>(
        WorkStore.instance.queries.customerOrders.getProducts(id.toString()));

    return r;
  }
}
