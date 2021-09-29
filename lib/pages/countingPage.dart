import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/pages/loadingPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/views/scanView.dart';
import 'abstractPage.dart';

class CountingPage extends StatefulWidget implements AbstractPage {
  @override
  _State createState() => _State();
  final String name;
  CountingPage(this.name);
}

class _State extends State<CountingPage> {
  WorkStore workStore = AppStore.injector.get<WorkStore>();
  //MediaQueryData mediaQueryData;
  Size scanViewSize;

  Future<Sequence> futureSequence;

  @override
  void initState() {
    super.initState();
    futureSequence = workStore.getCollection();
  }

  void setSizes(BuildContext context) {
    var screenSize = MediaQuery.of(this.context).size;
    var cameraViewHeight = screenSize.height * 0.5;
    this.scanViewSize = Size(screenSize.width, cameraViewHeight);
  }

  // alls pages should have future builder, more or less
  FutureBuilder futureBuilder() => FutureBuilder<Sequence>(
      future: futureSequence,
      builder: (BuildContext context, AsyncSnapshot<Sequence> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }

        if (this.scanViewSize == null) {
          setSizes(context);
        }

        return page(snapshot.data);
      });

  CameraView cameraView;
  int totalTimesScanned = 0;
  // the future values needed for the page. add it to abstract page maybe
  Widget page(Sequence sequence) {
    return Scaffold(
        //appBar: WMSAppBar(this.widget.name).get(),
        body: content(),
        extendBodyBehindAppBar: true);
  }

  Widget content() {
    return Container(
        child: (Column(children: [
      CameraView(), //,
      ScanView() // camera view part of page and recontructed on 'scannedProducts' state change
    ])));
  }

  @override
  Widget build(BuildContext context) {
    return futureBuilder();
  }

  // some sort of view that shows db sku suggestions, from image local sku.

  Widget productView(Product product) {
    return ProductView(product);
  }
}
