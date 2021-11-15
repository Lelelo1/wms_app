import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';

// need to design for mulitiple screen sizes:

class SearchProductView extends StatelessWidget {
  AbstractProduct product;
  double width = 0;
  double height = 0;
  SearchProductView(this.product, this.width /*, this.height*/);
// firstRow(), secondRow()
  int columnCount = 2;
  double imageHeight = 0;
  @override
  Widget build(BuildContext context) {
    print("build searchproductview");
    return Column(children: [
      Padding(child: nameCard(), padding: EdgeInsets.only(top: 20)),
      Padding(child: thirdRow(), padding: EdgeInsets.only(top: 150))
    ]);
  }

  static BorderRadiusGeometry borderRadiusGeometry = BorderRadius.circular(35);

  /*
  static List<BoxShadow> boxShadow = [
    BoxShadow(color: Color.fromARGB(130, 154, 119, 209), spreadRadius: 3)
  ];
  */
  static BoxDecoration boxDecoration = BoxDecoration(
      /*border: Border.all(color: Colors.blueAccent),*/ // looks extremely ugly, needs more borderWidth probably
      borderRadius: borderRadiusGeometry);

// card has ineherent padding, but can't be set.. :https://stackoverflow.com/questions/57730800/how-to-remove-a-cards-inner-padding-in-flutter

  Widget nameCard() {
    return Card(
        child: Padding(
      child: nameWidget(),
      padding: EdgeInsets.all(20),
    ));
  }

  Widget nameWidget() => WMSAsyncWidget<String>(this.product.getName(),
      (name) => Text(name, style: TextStyle(fontSize: 20)));

  // potentially blur list and focus what product: https://stackoverflow.com/questions/60585494/i-cant-make-blurred-item-with-sharp-border

  Widget thirdRow() {
    print("imageHeight is: " + this.imageHeight.toString());
    return imageWidget();
  }

  /*
  // methods given in 'Product's class order
  Widget nameWidget() => WMSAsyncWidget<String>(product?.getName(),
      (String name) => Text(name, style: TextStyle(fontSize: 20)));
  */
  Widget shelfWidget() => WMSAsyncWidget<String>(product.getShelf(),
      (shelf) => Text(shelf, style: TextStyle(fontSize: 22)));

  Widget skuWidget() => WMSAsyncWidget<String>(
      product.getSKU(),
      (sku) => Text(sku,
          style: TextStyle(fontSize: 38), textAlign: TextAlign.center));

  Widget boxWidget() {
    return Text("Boxnummer: " + "some box (not implemented)");
  }

  Widget imageWidget() {
    // string uri, url
    return Image.asset("assets/images/product_placeholder.png");
  }

  // I really don't understand why there should be a barcode value displayed..? (has not ben mentioned more times)

  /* 
  Widget barcodeWidget() {
    var streckod = Utils.hasValue(product?.barcode)
        ? product?.barcode.toString()
        : "Saknas";

    print("Streckkod: " + streckod);
    return Text("Streckkod: " + streckod);
  }
  */
}
