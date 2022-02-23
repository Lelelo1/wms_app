import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/extended/stacked.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

typedef Transition = Widget Function(Product p, String ean);

class Transitions {
  static Transition imageContent = (Product p, String ean) {
    if (p.exists()) {
      return WMSAsyncWidget<String>(p.getShelf(),
          (shelf) => _cameraContent(_shelfWidget(shelf), _scanSymbol(shelf)));
    }

    if (ean.isNotEmpty) {
      return _cameraContent(_eanWidget(ean), _scanSymbol(""));
    }

    return WMSEmptyWidget();
  };

  static Widget _cameraContent(Widget cameraContent, Widget scanSymbol) {
    return Column(children: [
      Spacer(flex: 12),
      Expanded(flex: 3, child: WMSStacked(cameraContent, scanSymbol))
    ]);
  }

  static Widget _shelfWidget(String shelf) => Align(
      child: Text(shelf, style: TextStyle(color: Colors.pink, fontSize: 32)));

  static Widget _eanWidget(String ean) => Align(
      child: Text(ean, style: TextStyle(color: Colors.pink, fontSize: 28)));

  static Widget _scanSymbol(String text) {
    var iconData = text.isEmpty
        ? MaterialCommunityIcons.barcode_scan
        : MaterialCommunityIcons.qrcode_scan;

    return Align(
        child: Row(children: [
      Spacer(flex: 20),
      Icon(iconData, size: 35, color: Colors.white),
      Spacer(flex: 1)
    ]));
  }

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
