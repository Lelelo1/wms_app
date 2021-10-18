import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';

// needs proper sizing for mulitple screen sizes !!

// https://trello.com/c/sgBxC7JO/7-förslag-layout

// Should look like (in the first scetch):
// Hyllplats :  Artikelnummer
// Namn : Box

// https://stackoverflow.com/questions/60133733/non-final-field-in-stateless-flutter-widget
// ignore: must_be_immutable
class SearchProductView extends StatelessWidget {
  AbstractProduct product;

  SearchProductView(AbstractProduct product) {
    // asume as product, handle outside
    this.product = product;
  }
// firstRow(), secondRow()
  int columnCount = 2;
  double imageHeight;
  @override
  Widget build(BuildContext context) {
    if (imageHeight == null) {
      imageHeight = MediaQuery.of(context).size.height * 0.2;
    }
    return Column(children: [topDetails(), thirdRow()]);
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

  Widget topDetails() {
    return Card(
        child: Container(
            child: Column(
                children: [skuWidget(), SizedBox(height: 10), nameWidget()]),
            padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10)),
        color: Color.fromARGB(210, 209, 251, 255),
        margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0));
  }

  // potentially blur list and focus what product: https://stackoverflow.com/questions/60585494/i-cant-make-blurred-item-with-sharp-border

  Widget thirdRow() {
    print("imageHeight is: " + this.imageHeight.toString());
    return Container(
        child: imageWidget(),
        color: Color.fromARGB(210, 200, 200, 200),
        margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
        height: this.imageHeight);
  }

  // methods given in 'Product's class order
  Widget nameWidget() => WMSAsyncWidget<String>(product?.getName(),
      (String name) => Text(name, style: TextStyle(fontSize: 20)));

  Widget shelfWidget() => WMSAsyncWidget(product?.getShelf(),
      (shelf) => Text(shelf, style: TextStyle(fontSize: 22)));

  Widget skuWidget() => WMSAsyncWidget(
      product?.getSKU(),
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
