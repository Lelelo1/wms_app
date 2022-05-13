import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:collection/collection.dart';
import 'package:wms_app/warehouseSystem/wsSqlQuery.dart';

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

  Future<double> getTotalProductsQuantity() async {
    var ids = await getProducts();
    var quantities = await Future.wait(ids.map((e) => getProductQuantity(e)));

    return quantities.sum;
  }

  Future<double> getProductQuantity(int productId) async {
    var r = await WSInteract.remoteSql<double>(WorkStore
        .instance.queries.customerOrders
        .getProductQuantity(id.toString(), productId.toString()));
    var rp = Default.firstDoubleDefaultTo(r);
    return rp;
  }

  Future<String> getIncrementId() async {
    var r = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries.customerOrders
        .getIncrementId(id.toString()));
    return Default.firstStringDefaultTo(r);
  }

  String formatCustomerOrderProductsQuantity(dynamic f) {
    return (f as double).round().toString() + "st";
  }
/*
  static Future<List<CustomerOrder>> fetch() async  {
    var customerOrders = await WSInteract.remoteSql<int>(
        WorkStore.instance.queries.customerOrders.getCustomerOrders());

    var s = customerOrders.map((e) => );
    WSInteract.remoteSql<int?>(WorkStore.instance.queries.customerOrders.getQtyPicked(orderId, productId))
  }
  */
/*
  // handle selected and not selected
  void setQtyPicked(String productId, int qtyPicked) {

    if (qtyPicked == qty) {
      print("productId: " +
          productId.toString() +
          "was already changed by somone");
      return;
    }

    if (selected == isPicked) {
      // might have been picked by someone else
      return;
    }

    WSInteract.remoteSql(WorkStore.instance.queries.customerOrders
        .setQtyPicked(id.toString(), productId));
  }

  bool isPicked(int? qtyPicked) => qtyPicked != null;
  */
}
