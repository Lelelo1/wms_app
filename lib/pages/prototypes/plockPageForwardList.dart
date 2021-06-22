import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/stores/test.dart';

class PlockPageForwardList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PlockPageForwardList> {
  List<Product> productItems;

  Iterator<Product> collect;

  // starting with first product in 'plocklista'
  // init state if needed

  @override
  void initState() {
    super.initState();
    productItems = Products.get();

    collect = productItems.reversed.iterator; // creates an iterator
    // to make first item the one to collect
    collect.moveNext();
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
    if (collect.current == null) {
      // show something somwhere to indicate that plock is done
      // return null; can't return null in flutter, atleast not in 'Column'
      return SizedBox();
    }
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

  Widget collectButton() {
    // 'plockad'
    return FloatingActionButton(
        // needs to be separated out
        onPressed: () {
          if (collect.current == null) {
            print("ignore, have finished collecting items");
            return;
          }
          setState(() {
            collect.moveNext();
          });
        },
        child: Icon(Icons.arrow_upward),
        backgroundColor: Colors.green);
  }
}
