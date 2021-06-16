import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/productView.dart';
import 'package:wms_app/stores/test.dart';

class PlockPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PlockPage> {
  List<Product> productItems;

  Iterator<Product> collect;

  // starting with first product in 'plocklista'
  // init state if needed

  @override
  void initState() {
    super.initState();
    productItems = Products.get();
    // list always retrurn a new iterator: https://stackoverflow.com/questions/65659282/iterator-current-is-null-but-why
    // so nade to create on once and save it
    collect = productItems.iterator; // to make first item the one to collect

    collect.moveNext(); // to start at the first item
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is calle
    return Scaffold(
        appBar: AppBar(
          title: Text("Plock"),
        ),
        body: Column(
            children: <Widget>[renderList(), renderDetails()],
            mainAxisAlignment: MainAxisAlignment.start),
        floatingActionButton: collectButton());
  }

  // ListView needs a fixed height, when put into column..
  // fix https://stackoverflow.com/questions/51266307/listview-inside-the-scroll-view-in-flutter
  Widget renderList() {
    return Container(
        child: ListView(
            children: List.from(productItems.map(renderItem)),
            shrinkWrap: true));
  }

  Widget renderItem(Product product) {
    var color = product == collect.current ? Colors.amber : Colors.white;

    return Card(child: Text(product.name), color: color);
  }

  Widget renderDetails() {
    print("collectProduct is: " + collect.current.toString());

    return ProductView(collect.current);
  }

/*
  Widget renderBottom() {
    return Column(
        children: [
          
        ],
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end);
  }
*/

  bool collectionCompleted = false; // does not help crash on last iteration..
  Widget collectButton() {
    // 'plockad'
    return FloatingActionButton(
        // needs to be separated out
        onPressed: () {
          if (collectionCompleted) {
            print("collection was completed");
            return;
          }

          setState(() {
            // when next is false, there no further elements: https://api.dart.dev/stable/2.12.1/dart-core/Iterator/moveNext.html
            // '!' anoying, rename bool..
            collectionCompleted = !collect.moveNext();
          });
        },
        child: Icon(Icons.arrow_upward));
  }
}
