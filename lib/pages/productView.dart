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
          children: [firstRow(), secondRow(), thirdRow()],
        ),
        color: Colors.grey.withOpacity(0.6));
  }

  static EdgeInsets rowInsets =
      EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20);

  static BorderRadiusGeometry borderRadiusGeometry = BorderRadius.circular(35);

  static List<BoxShadow> boxShadow = [
    BoxShadow(color: Color.fromARGB(130, 154, 119, 209), spreadRadius: 3)
  ];

  static BoxDecoration boxDecoration = BoxDecoration(
      /*border: Border.all(color: Colors.blueAccent),*/ // looks extremely ugly, needs more borderWidth probably
      borderRadius: borderRadiusGeometry,
      boxShadow: boxShadow);

// https://stackoverflow.com/questions/52774921/space-between-columns-children-in-flutter
  static SizedBox productPadding = SizedBox(width: 30);

  Widget firstRow() {
    return Container(
      child: Row(
          children: [shelfWidget(), productPadding, numberWidget()],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly),
      margin: rowInsets,
      decoration: boxDecoration,
    );
  }

  Widget secondRow() {
    return Container(
        child: Row(
            children: [nameWidget(), productPadding, boxWidget()],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly),
        margin: rowInsets,
        decoration: boxDecoration);
  }

  Widget thirdRow() {
    return Container(
        child: Row(
            children: [imageWidget(), barcodeWidget()],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly),
        margin: rowInsets);
  }

  // methods given in 'Product's class order
  Widget nameWidget() {
    return Text("Namn: " + product?.name);
  }

  Widget shelfWidget() {
    return Text("Hyllplats: " + product?.shelf);
  }

  Widget numberWidget() {
    return Text("Artikelnummer: " + product?.number.toString());
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

  Widget barcodeWidget() {
    var streckod = Utils.hasValue(product?.barcode)
        ? product?.barcode.toString()
        : "Saknas";

    print("Streckkod: " + streckod);
    return Text("Streckkod: " + streckod);
  }
}
