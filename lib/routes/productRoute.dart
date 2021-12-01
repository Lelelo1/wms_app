import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wms_app/models/flexibleProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsLabel.dart';

// mobx needs stateful widget to work
class ProductRoute extends StatefulWidget {
  final Product product;

  ProductRoute(this.product);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductRoute> {
  Size size = Size.zero;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
        child: Column(children: [
      titleArea(),
      subtitleArea(),
      imageArea(),
      shelfWidget(),
      nameWidget()
      //WMSAsyncWidget(this.product.getEAN(), (String name) => Text(name)), // barcode icon
    ]));
  }

  double skuPadding() => this.size.height * 0.02;
  Widget titleArea() => WMSAsyncWidget(
      this.widget.product.getSKU(),
      (String sku) => Padding(
          padding: EdgeInsets.only(top: skuPadding(), bottom: skuPadding()),
          child: Text(sku,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400))));

  EdgeInsets eanIdPadding() => EdgeInsets.only(
      left: 5, top: this.skuPadding() * 0.6, right: 5, bottom: 0);

  Widget subtitleArea() => Row(children: [
        WMSAsyncWidget(
            this.widget.product.getEAN(),
            (String shelf) =>
                WMSLabel(shelf, LineIcons.barcode, this.eanIdPadding())),
        WMSAsyncWidget(Future.sync(() => this.widget.product.id.toString()),
            (String id) => WMSLabel(id, Icons.desktop_windows, eanIdPadding()))
      ], mainAxisAlignment: MainAxisAlignment.center);

  Size imageSize() => new Size(400, 400);
  EdgeInsets imagePadding() => EdgeInsets.only(
      left: 5, top: skuPadding(), right: 5, bottom: skuPadding());

  Widget imageArea() =>
      WMSAsyncWidget(this.widget.product.getImages(), (List<String> imgs) {
        if (Utils.isNullOrEmpty(imgs)) {
          return Padding(
              child: Image.asset("assets/images/product_placeholder.png"),
              padding: imagePadding());
        }

        return Padding(child: flipImage(imgs), padding: imagePadding());
      });

  // move to uu effect folder/package
  Widget flipImage(List<String> imgs) {
    var frontImage = Image.network(imgs[0],
        width: imageSize().width, height: imageSize().height);
    if (imgs.length == 0) {
      return frontImage;
    }

    var backImage = Image.network(imgs[1],
        width: imageSize().width, height: imageSize().height);
    return FlipCard(
      fill: Fill
          .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      front: frontImage,
      back: backImage,
    );
  }

  Widget shelfWidget() => WMSAsyncWidget(this.widget.product.getShelf(),
      (String shelf) => Text(shelf, style: TextStyle(fontSize: 18)));

  Widget nameWidget() => WMSAsyncWidget(
      this.widget.product.getName(),
      (String name) => Padding(
          padding: EdgeInsets.all(10),
          child: Text(name,
              style: TextStyle(fontSize: 15), textAlign: TextAlign.center)));

  // Future.sync(() => "mockShelf")

  // do some common text aliging with padding, and also common fotsize, large title medium title, normal fontsize eg

  // icons for every attribute?
  // sku:
  // id -> Icons.desktop_windows
  // ean -> LineIcons.barcode)
  // shelf -> Icon(LineIcons.warehouse // cound't find anny better...
  // (img)
  // Icon(Icons.text_format) // can be made better
}
