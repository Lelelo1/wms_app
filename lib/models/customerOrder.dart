import 'package:wms_app/models/customerOrderProduct.dart';

import 'package:wms_app/utils.dart';

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
          (e) => double.parse(Utils.getAndDefaultAs(e.qtyPicked, 0.toString())))
      .sum();
}
