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
        ...products.map((p) => Container(
            child: productInformation(p),
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.85))
      ])
    ]));
  }

  Widget productInformation(Product product) {
    return SafeArea(
        child: Column(children: [
      ProductInformationWidgets.titleArea(product.sku),
      ProductInformationWidgets.subtitleArea(
          product.id.toString(), product.ean.toString()),
      ProductInformationWidgets.imageArea(
          [product.frontImage, product.backImage]),
      ProductInformationWidgets.bottomArea(product.shelf, product.qty),
      ProductInformationWidgets.nameWidget(product.name)
    ]));
  }
}
