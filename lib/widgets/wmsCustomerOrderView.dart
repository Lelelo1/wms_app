import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

class WMSCustomerOrderView extends StatelessWidget {
  final String customerName;
  final List<Product> products;

  WMSCustomerOrderView(this.customerName, this.products);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Text(customerName,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      Column(children: [
        ...products
            .map((p) => ProductRoute(p, WMSEmptyWidget(), Size(360, 360)))
      ])
    ]));
  }
}
