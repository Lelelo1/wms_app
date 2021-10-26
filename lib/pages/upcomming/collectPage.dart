/*
import 'package:flutter/material.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/pages/loadingPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';

import 'abstractPage.dart';

class CollectPage extends StatefulWidget implements AbstractPage {
  @override
  _State createState() => _State();
  final String name;
  CollectPage(this.name);
}

class _State extends State<CollectPage> {
  WorkStore workStore = AppStore.injector.get<WorkStore>();

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

        return page(snapshot.data);
      });

  // the future values needed for the page. add it to abstract page maybe
  Widget page(Sequence sequence) {
    return Scaffold(
        appBar: WMSAppBar(this.widget.name).get(),
        body: Container(
            child: (Column(children: [
          CameraView(null),
          Expanded(child: productView(sequence.iterator.current))
        ]))),
        extendBodyBehindAppBar: true);
  }

  @override
  Widget build(BuildContext context) {
    return futureBuilder();
  }

/*
  Widget top() {
    var topHeightFactor = 0.31;
    var topHeight = mediaQueryData.size.height * topHeightFactor;
    var statusBarHeight = mediaQueryData.padding.top;

    var buttonWidthFactor = 0.65;
    var buttonWidth = mediaQueryData.size.width * buttonWidthFactor;
    var buttonHeightFactor = 0.08;
    var buttonHeight = mediaQueryData.size.height * buttonHeightFactor;

    return Container(
        child: Center(
          child: SizedBox(
            child: MaterialButton(
                child: Icon(Icons.qr_code),
                onPressed: scan,
                color: Color.fromARGB(180, 133, 57, 227),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0),
            width: buttonWidth,
            height: buttonHeight,
          ),
        ),
        color: Colors.white,
        height: topHeight,
        margin: EdgeInsets.only(
            left: 0, top: 0 /*statusBarHeight*/, right: 0, bottom: 0));
  }
*/
  Widget productView(Product product) {
    return ProductView(product);
  }

  void scan() {
    print("scan");
  }
}
*/
