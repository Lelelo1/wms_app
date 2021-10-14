import 'package:flutter/material.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/pages/loadingPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/views/scanView.dart';
import 'abstractPage.dart';

class ScanPage extends StatefulWidget {
  final String name;
  final void Function(String product) onSuccesfullScan;
  ScanPage(this.name, this.onSuccesfullScan);

  @override
  _State createState() => _State();
}

class _State extends State<ScanPage> {
  WorkStore workStore = AppStore.injector.get<WorkStore>();
  //MediaQueryData mediaQueryData;

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

  CameraView cameraView;
  int totalTimesScanned = 0;
  // the future values needed for the page. add it to abstract page maybe
  Widget page(Sequence sequence) {
    return Scaffold(
        //appBar: WMSAppBar(this.widget.name).get(),
        body: content(),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset:
            false); // https://stackoverflow.com/questions/49840074/keyboard-pushes-the-content-up-resizes-the-screen
  }

  // conditional renderering, searchView
  Widget content() {
    return Column(children: [
      CameraView(),
      ScanView(0.44, this.widget.onSuccesfullScan)
    ] // camera view part of page and recontructed on 'scannedProducts' state change
        );
  }

  // animate scanview height changes..?

  @override
  Widget build(BuildContext context) {
    return futureBuilder();
  }

  // some sort of view that shows db sku suggestions, from image local sku.
  /*
  Widget productView(Product product) {
    return ProductView(product);
  }
  */
}
