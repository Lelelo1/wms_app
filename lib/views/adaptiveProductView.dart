import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/plockStore.dart';

class AdaptiveProductView extends StatelessWidget {
  final PlockStore plockStore = AppStore.injector.get<PlockStore>();
  @override
  Widget build(BuildContext context) {
    var product = plockStore.collect.current;

    return Container(
      child: Column(children: [shelf(product), number(product), name(product)]),
      color: Colors.brown,
    );
  }

  Widget shelf(Product product) {
    return Row(children: [Icon(Icons.shuffle), Text(product.shelf)]);
  }

  Widget number(Product product) {
    return Text(product.number.toString(), style: TextStyle(fontSize: 25));
  }

  Widget name(Product product) {
    return Container(
        child: Column(
      children: [
        SizedBox(child: Icon(Icons.book), width: 100, height: 100),
        Text(
          product.name,
          style: TextStyle(fontSize: 20),
        )
      ],
    ));
  }
}
