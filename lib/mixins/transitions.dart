import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/extended/stacked.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

import '../utils.dart';

typedef Transition = Widget Function(Product p, String ean);

class Transitions {
  static Transition imageContent = (Product p, String ean) {
    return WMSAsyncWidget<String>(
        defaultEmptyText(p, ean), (shelf) => _cameraContent(shelf));
  };

  static Future<String> defaultEmptyText(Product p, String ean) {
    if (!p.exists()) {
      return Future.sync(() => "");
    }

    return p.getShelf();
  }

  static Widget _cameraContent(String text) {
    var icon = text.isEmpty ? LineIcons.barcode : LineIcons.qrcode;

    return Column(children: [
      Spacer(flex: 12),
      Expanded(
        flex: 3,
        child: WMSStacked(_shelfText(text), _scanSymbol(icon)),
      )
    ]);
  }

  static Widget _shelfText(String text) => Align(
      child: Text(text, style: TextStyle(color: Colors.pink, fontSize: 32)));
  static Widget _scanSymbol(IconData icon) => Align(
          child: Row(children: [
        Spacer(flex: 10),
        Expanded(
          flex: 2,
          child: Icon(icon, size: 28),
        )
      ]));
// consider using align above?

/* Container(
                  child: Text(ean),
                  color: Color.fromARGB(80, 40, 7, 100),
                  width: 200,
                  height: 200))
*/
  static Transition fadeContent = (Product product, String ean) {
    if (product.exists() || Utils.isNullOrEmpty(ean)) {
      return WMSEmptyWidget();
    }

    return SearchRoute(SearchPage(product, ean));
  };

  static Transition scrollContent = (Product p, String ean) =>
      p.exists() ? ProductRoute(p) : WMSEmptyWidget();

  static Transition empty = (Product p, String ean) => WMSEmptyWidget();
}
