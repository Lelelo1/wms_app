import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';

class SearchProductView extends StatefulWidget {
  final AbstractProduct product;

  SearchProductView(this.product);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SearchProductView> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [skuWidget(), nameWidget()]);
  }

  Widget fillWidth(Widget widget) =>
      Row(children: [widget], mainAxisAlignment: MainAxisAlignment.center);

  Widget skuWidget() => WMSAsyncWidget(
      this.widget.product.getSKU(),
      (sku) => Card(
          child: Container(
              child: Text(sku, style: TextStyle(fontSize: 20)),
              padding: EdgeInsets.all((10)))));

  Widget nameWidget() => WMSAsyncWidget(
      this.widget.product.getName(),
      (name) => Card(
          child: Container(
              child: Text(name, style: TextStyle(fontSize: 20)),
              padding: EdgeInsets.all((10)))));
}
