import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/common/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

import '../utils.dart';

typedef Transition = Widget Function([Product p, String ean]);

class Transitions {
  static WorkStore store = WorkStore.instance;

  Transition imageContent =
      ([Product p = const Product.empty(), String ean = ""]) {
    return WMSAsyncWidget<String>(
        defaultEmptyText(p, ean), (shelf) => _cameraContent(shelf));
  };

  static Future<String> defaultEmptyText(Product p, String ean) {
    if (!p.exists()) {
      return Future.sync(() => "");
    }

    return p.getShelf();
  }

  static Widget _cameraContent(String text) => Column(children: [
        Spacer(flex: 12),
        Expanded(
            flex: 3,
            child: Align(
                child: Text(text,
                    style: TextStyle(color: Colors.pink, fontSize: 28))))
      ]);

// consider using align above?

/* Container(
                  child: Text(ean),
                  color: Color.fromARGB(80, 40, 7, 100),
                  width: 200,
                  height: 200))
*/
  Transition fadeContent =
      ([Product p = const Product.empty(), String ean = ""]) {
    if (p.exists() || Utils.isNullOrEmpty(ean)) {
      return WMSEmptyWidget();
    }

    return SearchRoute(SearchPage(ean));
  };

  Transition scrollContent = (
          [Product p = const Product.empty(), String ean = ""]) =>
      p.exists() ? ProductRoute(p) : WMSEmptyWidget();
}
