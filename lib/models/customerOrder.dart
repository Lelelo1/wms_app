import 'package:wms_app/models/customerOrderProduct.dart';

import 'package:wms_app/utils.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/warehouseSystem/wsSqlQuery.dart';

class CustomerOrder {
  List<CustomerOrderProduct> customerOrderProducts = List.empty();
  CustomerOrder(List<CustomerOrderProduct> customerOrderList) {
    this.customerOrderProducts = customerOrderList;
  }

  int get id => int.parse(customerOrderProducts.first.id);
  String get name => customerOrderProducts.first.name;
  String get displayId => customerOrderProducts.first.displayId;
  List<String> get productId =>
      customerOrderProducts.map((e) => e.productId).toList();
  double get qtyOrdered => customerOrderProducts
      .map((e) =>
          double.parse(Utils.getAndDefaultAs(e.qtyOrdered, 0.toString())))
      .sum();

  double get qtyPicked => customerOrderProducts
      .map(
          (e) => double.parse(Utils.getAndDefaultAs(e.productId, 0.toString())))
      .sum();

  bool get isPicked => !(getAnyPicked() == null);

  int? getAnyPicked() => Utils.toNullableInt(customerOrderProducts
      .map<String?>((e) => e.qtyPicked)
      .singleWhere((c) => !c.isNullOrEmpty(), orElse: () => ""));

// Could potenialy move some of this stuff into CustomerOrderProduct

  Future<void> setPicked(bool picked, String productId) async {
    var anyPicked = getAnyPicked();

    bool isAnyPicked = !(anyPicked == null);
    if (isAnyPicked) {
      bool pickingCanBeCancelled =
          double.parse(Utils.getAndDefaultAs(anyPicked, 0.toString())) == 0;
      if (pickingCanBeCancelled) {
        await _setQtyPicked(productId, null);
        return;
      }
      // not possible to stop a picking that has started (scanned atleast one item)
      return;
    }

    _setQtyPicked(productId, 0);
  }

  Future<void> _setQtyPicked(String productId, int? qtyPicked) async {
    await WSInteract.remoteSql(
        CustomerOrderQueries.setQtyPicked(id.toString(), productId, qtyPicked));
  }
}
