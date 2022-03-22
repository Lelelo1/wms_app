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
import '../utils.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

typedef Transition = Widget Function();

typedef ImageContentTransition = Widget Function(void Function() onPressAddEan);

class Transitions {
  static ImageContentTransition imageContent = (void Function() onPressAddEan) {
    var ean = WorkStore.instance.currentEAN;
    var p = WorkStore.instance.currentProduct;

    if (p.exists()) {
      return WMSAsyncWidget<String>(
          p.getShelf(),
          (shelf) => _cameraContent(
              _shelfWidget(shelf.replaceAll(AbstractProduct.shelfPrefix, "")),
              _scanSymbol(MaterialCommunityIcons.qrcode_scan)));
    }

    if (ean.isNotEmpty) {
      return _cameraContent(_eanWidget(ean, onPressAddEan),
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
  static Widget _eanWidget(String ean, void Function() onPressAddEan) => Center(
      child: TouchableOpacity(
          child: Row(children: [
            Icon(Icons.add, color: Colors.white),
            Text(ean, style: TextStyle(color: Colors.pink, fontSize: 26))
          ], mainAxisAlignment: MainAxisAlignment.center),
          onTap: onPressAddEan));

  static Widget _scanSymbol(IconData symbol) {
    return Align(
        child: Row(children: [
      Spacer(flex: 20),
      Icon(symbol, size: 35, color: Colors.white),
      Spacer(flex: 1)
    ]));
  }

  static Transition empty = () => WMSEmptyWidget();
}
