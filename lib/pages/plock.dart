import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/productView.dart';
import 'package:wms_app/stores/test.dart';

class PlockPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PlockPage> {
  List<ProductItem> productItems =
      List.from(Products.get().map((p) => ProductItem(p)));

  @override
  void initState() {
    super.initState();

    productItems.last.isHighlighted =
        true; // starting with first product in 'plocklista'
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is calle
    return Scaffold(
        appBar: AppBar(
          title: Text("Plock"),
        ),
        body: Column(children: <Widget>[renderList(), renderDetails()]));
  }

  // ListView needs a fixed height, when put into column..
  Widget renderList() {
    return Container(
      child: ListView(children: List.from(productItems.map(renderItem))),
      height: 400,
    );
  }

  Widget renderItem(ProductItem productItem) {
    var color = productItem.isHighlighted ? Colors.amber : Colors.white;
    return Card(child: Text(productItem.product.name), color: color);
  }

  Widget renderDetails() {
    return ProductView(productItems.first.product);
  }

  Widget renderBottom() {
    return FloatingActionButton(
        // needs to be separated out
        onPressed: () {
          nextItem();
        },
        child: Icon(Icons.arrow_upward));
  }

  // create a 'current' product to bind to, remove higlighted boolean
  // productItems.iterator.current.
  void nextItem() {
    print("nextItem");

    // if no highlighted product &&
    /*
    ProductItem currentProductItem =
        productItems.firstWhereOrNull((pi) => pi.isHighlighted);
    if (currentProductItem == null) {
      print("completed, there was no next product");
      return;
    }
    currentProductItem.isHighlighted = false;
    
    var isLastProduct =

    if () {
      print("end of list reached, final prodict was " +
          currentProductItem.product.name);
      return;
    }

    var nextItem = productItems[index];
    nextItem.isHighlighted = true;
    */
  }
}

// for list
class ProductItem {
  Product product; // the magento database product
  bool isHighlighted;

  ProductItem(Product product) {
    this.product = product;
    isHighlighted =
        false; // higlighted is the next product that shoul be 'plockad'
  }
}
