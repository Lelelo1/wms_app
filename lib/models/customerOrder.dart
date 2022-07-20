import 'package:wms_app/models/customerOrderProduct.dart';

import 'package:wms_app/utils.dart';

class CustomerOrder {
  List<CustomerOrderProduct> customerOrderProducts;
  CustomerOrder(this.customerOrderProducts);

  int get id => customerOrderProducts.first.id;
  String get name => customerOrderProducts.first.name;
  String get displayId => customerOrderProducts.first.displayId;
  List<String> get productId =>
      customerOrderProducts.map((e) => e.productId).toList();
  double get qtyOrdered =>
      customerOrderProducts.map((e) => double.parse(e.qtyOrdered)).sum();

  double get qtyPicked => customerOrderProducts.map((e) => e.qtyPicked).sum();
}
