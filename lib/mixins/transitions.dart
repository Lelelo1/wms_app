import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/common/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

typedef Transition = Widget Function([Product p, String ean]);

class Transitions {
  Transition imageContent = (
          [Product p = const Product.empty(), String ean = ""]) =>
      WMSAsyncWidget<String>(
          p.getShelf(),
          (shelf) => Row(children: [
                Spacer(flex: 1),
                Expanded(
                    flex: 1,
                    child: Column(children: [
                      Spacer(flex: 10),
                      Expanded(
                          flex: 1,
                          child: Text(shelf,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.pink)))
                    ])),
                Spacer(flex: 1)
              ]));

// consider using align above?

/* Container(
                  child: Text(ean),
                  color: Color.fromARGB(80, 40, 7, 100),
                  width: 200,
                  height: 200))
*/
  Transition fadeContent = (
          [Product p = const Product.empty(), String ean = ""]) =>
      p.exists() ? WMSEmptyWidget() : SearchRoute(SearchPage(ean));

  Transition scrollContent = (
          [Product p = const Product.empty(), String ean = ""]) =>
      p.exists() ? ProductRoute(p) : WMSEmptyWidget();
}
