import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/utils.dart';

// needs proper sizing for mulitple screen sizes !!

// https://trello.com/c/sgBxC7JO/7-förslag-layout

// Should look like (in the first scetch):
// Hyllplats :  Artikelnummer
// Namn : Box

// https://stackoverflow.com/questions/60133733/non-final-field-in-stateless-flutter-widget
// ignore: must_be_immutable
class ProductView extends StatelessWidget {
  Product product;

  ProductView(Product product) {
    // asume as product, handle outside
    this.product = product;
  }
// firstRow(), secondRow()
  int columnCount = 2;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [topDetails(), Expanded(child: thirdRow())],
        ),
        color: Colors.grey.withOpacity(0.6));
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
            child: Column(children: [
              shelfWidget(),
              SizedBox(height: 10),
              numberWidget()
            ]),
            padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10)),
        color: Color.fromARGB(210, 209, 251, 255),
        margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0));
  }

  // potentially blur list and focus what product: https://stackoverflow.com/questions/60585494/i-cant-make-blurred-item-with-sharp-border

  Widget thirdRow() {
    return Container(
        child: Row(children: [
          Flexible(child: imageWidget()),
        ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
        color: Color.fromARGB(210, 255, 255, 255),
        margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10));
  }

  // methods given in 'Product's class order
  Widget nameWidget() {
    return Text("Namn: " + product?.name);
  }

  Widget shelfWidget() {
    return Text(product?.shelf, style: TextStyle(fontSize: 22));
  }

  Widget numberWidget() {
    return Text(product?.number.toString(),
        style: TextStyle(fontSize: 38), textAlign: TextAlign.center);
  }

  Widget boxWidget() {
    return Text("Boxnummer: " + product?.box.toString());
  }

  Widget imageWidget() {
    // string uri, url
    return Icon(
      Icons.book,
      size: 120,
    );
  }

  // I really don't understand why there should be a barcode value displayed..?
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