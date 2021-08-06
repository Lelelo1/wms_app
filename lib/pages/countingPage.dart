import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/pages/loadingPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';

import 'abstractPage.dart';

class CountingPage extends StatefulWidget implements AbstractPage {
  @override
  _State createState() => _State();
  final String name;
  CountingPage(this.name);
}

class _State extends State<CountingPage> {
  WorkStore workStore = AppStore.injector.get<WorkStore>();
  MediaQueryData mediaQueryData;

  Future<Sequence> futureSequence;

  @override
  void initState() {
    super.initState();
    futureSequence = workStore.getCollection();
  }

  // alls pages should have future builder, more or less
  FutureBuilder futureBuilder() => FutureBuilder<Sequence>(
      future: futureSequence,
      builder: (BuildContext context, AsyncSnapshot<Sequence> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }

        if (this.mediaQueryData == null) {
          this.mediaQueryData = MediaQuery.of(context);
        }

        return page(snapshot.data);
      });

  // the future values needed for the page. add it to abstract page maybe
  Widget page(Sequence sequence) {
    return Scaffold(
        appBar: WMSAppBar(this.widget.name).get(),
        body: Container(
            child: (Column(children: [
          Expanded(child: CameraView()),
          Expanded(child: header())
        ]))),
        extendBodyBehindAppBar: true);
  }

  @override
  Widget build(BuildContext context) {
    return futureBuilder();
  }

  Widget header([String shelf = "D-3-2-C"]) {
    return Container(
        child: Center(child: Text(shelf, style: TextStyle(fontSize: 30))),
        color: Colors.white);
  }

  // some sort of view that shows db sku suggestions, from image local sku.

  Widget productView(Product product) {
    return ProductView(product);
  }

  void scan() {
    print("scan");
  }
}
