import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/extended/stacked.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsLabel.dart';
import 'package:wms_app/widgets/wmsWidget.dart';

// mobx needs stateful widget to work
class ProductRoute extends StatelessWidget implements WMSWidget {
  final Product product;
  final Widget eanAddButton;
  ProductRoute(
    this.product, [
    this.eanAddButton = const WMSEmptyWidget(),
  ]);

  @override
  Widget build(BuildContext context) {
    print("producRoute: " +
        product.toString() +
        "isEmpty: " +
        product.isEmpty.toString());
    return product.isEmpty ? WMSEmptyWidget() : content();
  }

  Widget content() {
    return Row(children: [
      Spacer(flex: 1),
      Expanded(child: safeArea(), flex: 12),
      Spacer(flex: 1)
    ]);
  }

  Widget safeArea() => SafeArea(
          child: Column(children: [
        Expanded(
            child: ProductInformationWidgets.titleArea(this.product.sku),
            flex: 3),
        Expanded(
            child: ProductInformationWidgets.subtitleArea(
                this.product.id.toString(), this.product.ean.toString()),
            flex: 4),
        Expanded(
            child: ProductInformationWidgets.imageArea(
                [this.product.frontImage, this.product.backImage]),
            flex: 34),
        Spacer(flex: 2),
        Expanded(
            child: ProductInformationWidgets.bottomArea(
                product.shelf, product.qty),
            flex: 4),
        Expanded(
            child: ProductInformationWidgets.nameWidget(product.name), flex: 4),
        ...ProductInformationWidgets.eanAddButtonView(eanAddButton)
      ]));

  @override
  // TODO: implement empty
  bool get empty => this.product.isEmpty;
}

class ProductInformationWidgets {
  static List<Widget> eanAddButtonView(Widget eanAddButton) =>
      eanAddButton is WMSEmptyWidget
          ? [eanAddButton]
          : [
              Spacer(flex: 1),
              Expanded(child: eanAddButton, flex: 5),
              Spacer(flex: 3)
            ];

  static Widget titleArea(String title) => FittedBox(
      child: Text(title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)));

  static Widget nameWidget(String name) =>
      Text(name, style: TextStyle(fontSize: 15), textAlign: TextAlign.center);

  static Widget bottomArea(String shelf, double quantity) => WMSStacked(
      Row(
          children: [_shelfWidget(shelf)],
          mainAxisAlignment: MainAxisAlignment.center),
      Row(
          children: [_quantityWidget(quantity)],
          mainAxisAlignment: MainAxisAlignment.end));

  static Widget _shelfWidget(String shelf) =>
      Text(shelf, style: TextStyle(fontSize: 18));

  static Widget _quantityWidget(double quantity) =>
      Text((quantity.round().toString() + "st"));

  static Widget subtitleArea(String id, String subtitle) => Row(children: [
        WMSLabel(subtitle, LineIcons.barcode),
        WMSLabel(id, Icons.desktop_windows)
      ], mainAxisAlignment: MainAxisAlignment.center);

  static Widget imageArea(List<String> images) {
    if (images.isEmpty) {
      return Image.asset("assets/images/product_placeholder.png",
          width: double.infinity, fit: BoxFit.fitWidth);
    }
    return _flipImage(images);
  }

  static Widget _flipImage(List<String> imgs) {
    var frontImage = Image.network(imgs[0]);
    if (imgs.length == 1) {
      return frontImage;
    }

    var backImage = Image.network(imgs[1]);
    return FlipCard(
      fill: Fill
          .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      front: frontImage,
      back: backImage,
    );
  }
}
