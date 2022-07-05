import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:collection/collection.dart';

class CustomerOrder {
  final int id;
  CustomerOrder(this.id);

  Future<String> _getCustomerFirstName() async {
    /*
    var r = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries.customerOrders
        .getCustomerFirstName(id.toString()));

    if (r.isEmpty) {
      return "-";
    }
*/
    return ""; //Default.firstStringDefaultTo(r);
  }
/*
  Future<String> _getCustomerLastName() async {
    var r = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries.customerOrders
        .getCustomerLastName(id.toString()));

    return Default.firstStringDefaultTo(r, "-");
  }
  */

  Future<String> getCustomerName() {
    return Future.sync(() async {
      //var firstName = await _getCustomerFirstName();
      //var lastName = await _getCustomerLastName();

      return "customer name"; //firstName + " " + lastName;
    });
  }

  Future<List<int>> getProducts() async {
    /*var r = await WSInteract.remoteSql<int>(
        WorkStore.instance.queries.customerOrders.getProducts(id.toString()));
    */
    return [];
  }

  Future<double> getTotalProductsQuantity() async {
    var ids = await getProducts();
    var quantities = await Future.wait(ids.map((e) => getProductQuantity(e)));

    return quantities.sum;
  }

  Future<double> getProductQuantity(int productId) async {
    /*
    var r = await WSInteract.remoteSql<double>(WorkStore
        .instance.queries.customerOrders
        .getProductQuantity(id.toString(), productId.toString()));
    var rp = Default.firstDoubleDefaultTo(r);
    */
    return 0;
  }

  Future<String> getIncrementId() async {
    /*
    var r = await WSInteract.remoteSql<String>(WorkStore
        .instance.queries.customerOrders
        .getIncrementId(id.toString()));
        */
    return ""; //Default.firstStringDefaultTo(r);
  }

  String formatCustomerOrderProductsQuantity(dynamic f) {
    return (f as double).round().toString() + "st";
  }

  Future<bool> getIsSelected() async {
    var productIds = await getProducts();
    var quantitiesPicked =
        await Future.wait(productIds.map((p) => _getQtyPicked(p)));
    var isAvailable = quantitiesPicked.any((e) => e == null);

    return !isAvailable;
  }

  Future<bool> getIsBeingCollected() async {
    var productIds = await getProducts();
    var quantitiesPicked =
        await Future.wait(productIds.map((p) => _getQtyPicked(p)));
    var isBeingCollected = quantitiesPicked.any((e) {
      var qtyPicked = e ?? 0;
      return qtyPicked > 0;
    });

    return isBeingCollected;
  }

  Future<int?> _getQtyPicked(int productId) async {
    /*
    var r = await WSInteract.remoteSql<int?>(WorkStore
        .instance.queries.customerOrders
        .getQtyPicked(id.toString(), productId.toString()));
        */
    return 0; //Default.firstNullableIntDefaultTo(r);
  }

  void setQtyPicked(String productId, int? qty) {
    WSInteract.remoteSql(WorkStore.instance.queries.customerOrders
        .setQtyPicked(id.toString(), productId, qty));
  }

  Future<bool> setQtyPickedFromChecked(bool isChecked) async {
    var productIds = await getProducts();
    var checked = await Future.wait(
        productIds.map((p) => _setQtyPickedFromChecked(p, isChecked)));
    return checked.contains(true);
  }

  Future<bool> _setQtyPickedFromChecked(int productId, bool isChecked) async {
    var currentQtyPicked = await _getQtyPicked(productId);

    if (currentQtyPicked == null || currentQtyPicked == 0) {
      var setQty = isChecked ? 0 : null;
      WSInteract.remoteSql(WorkStore.instance.queries.customerOrders
          .setQtyPicked(id.toString(), productId.toString(), setQty));
      return true;
    }

    print("A picking for order with order_id: " +
        id.toString() +
        " incriment_id: " +
        await getIncrementId() +
        " was already started. It should not appear in the list of available picking orders");

    return false;
  }
}
