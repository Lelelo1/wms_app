import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/views/extended/stacked.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

class WMSCustomerOrderView extends StatelessWidget {
  final String customerName;
  final List<Product> products;

  WMSCustomerOrderView(this.customerName, this.products);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(customerName,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      Column(children: [
        ...products.map((p) => Card(
            child: Container(
                child: productInformation(p),
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.85),
            margin: EdgeInsets.all(10)))
      ])
    ]);
  }

  Widget productInformation(Product product) {
    return Column(children: [
      ProductInformationWidgets.titleArea(product.sku),
      ProductInformationWidgets.subtitleArea(
          product.id.toString(), product.ean.toString()),
      Image.network(product.frontImage),
      ProductInformationWidgets.bottomArea(product.shelf, product.qty),
      ProductInformationWidgets.nameWidget(product.name),
      Checkbox(value: true, onChanged: (b) {})
    ]);
  }
}
