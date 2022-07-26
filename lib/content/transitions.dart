import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/views/extended/stacked.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

typedef Transition = Widget Function(BuildContext context);

class Transitions {
  static EventSubscriber pageContent(Transition imageContent) =>
      EventSubscriber(
          event: WorkStore.instance.productEvent,
          handler: (context, __) => WMSScrollable(
              ScanPage(imageContent(context)),
              ProductRoute(WorkStore.instance.currentProduct)));

  static Transition imageContent = (BuildContext context) {
    var ean = WorkStore.instance.currentEAN;
    var p = WorkStore.instance.currentProduct;

    if (p.exists) {
      return _cameraContent(_shelfWidget(p.shelf),
          _scanSymbol(MaterialCommunityIcons.qrcode_scan));
    }

    if (ean.isNotEmpty) {
      return _cameraContent(_eanWidget(ean, context),
          _scanSymbol(MaterialCommunityIcons.barcode_scan));
    }

    return _cameraContent(
        WMSEmptyWidget(), _scanSymbol(MaterialCommunityIcons.barcode_scan));
  };

  static Widget _cameraContent(Widget cameraContent, Widget scanSymbol) {
    return Column(children: [
      Spacer(flex: 12),
      Expanded(flex: 3, child: WMSStacked(cameraContent, scanSymbol))
    ]);
  }

  static Widget _shelfWidget(String shelf) => Align(
      child: Text(shelf, style: TextStyle(color: Colors.pink, fontSize: 32)));

  static String plusEmoji = "\u{2795}";
  static Widget _eanWidget(String ean, BuildContext context) => Center(
      child: TouchableOpacity(
          child: Row(children: [
            Icon(Icons.add, color: Colors.white),
            Text(ean, style: TextStyle(color: Colors.pink, fontSize: 26))
          ], mainAxisAlignment: MainAxisAlignment.center),
          onTap: () {
            var product = WorkStore.instance.currentProduct;
            var ean = WorkStore.instance.currentEAN;
            if (product.exists || Utils.isNullOrEmpty(ean)) {
              return;
            }
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        SearchRoute(SearchPage(product, ean))));
          }));

  static Widget _scanSymbol(IconData symbol) {
    return Align(
        child: Row(children: [
      Spacer(flex: 20),
      Icon(symbol, size: 35, color: Colors.white),
      Spacer(flex: 1)
    ]));
  }

  static Transition empty = (BuildContext context) => WMSEmptyWidget();
}
