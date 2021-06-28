import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/plockStore.dart';
import 'package:wms_app/views/productView.dart';

class PlockPageForwardList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PlockPageForwardList> {
  // starting with first product in 'plocklista'
  // init state if needed

  PlockStore plockStore = AppStore.injector.get<PlockStore>();

  @override
  void initState() {
    super.initState();
    // changing collect order of list, once
    plockStore.collect = plockStore.productItems.reversed.iterator;
    // to make first item the one to collect
    plockStore.collect.moveNext();
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
            children: List.from(plockStore.productItems.map(renderItem)),
            shrinkWrap: true));
  }

  Widget renderItem(Product product) {
    var color =
        product == plockStore.collect.current ? Colors.amber : Colors.white;

    return Card(child: Text(product.name), color: color);
  }

  Widget renderDetails() {
    if (plockStore.collect.current == null) {
      // show something somwhere to indicate that plock is done
      // return null; can't return null in flutter, atleast not in 'Column'
      return SizedBox();
    }
    return ProductView(plockStore.collect.current);
  }

  Widget collectButton() {
    // 'plockad'
    return FloatingActionButton(
        // needs to be separated out
        onPressed: () {
          if (plockStore.collect.current == null) {
            print("ignore, have finished collecting items");
            return;
          }
          setState(() {
            plockStore.collect.moveNext();
          });
        },
        child: Icon(Icons.arrow_upward),
        backgroundColor: Colors.green);
  }
}
