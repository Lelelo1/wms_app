import 'package:flutter/material.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/extended/stacked.dart';
import 'package:wms_app/views/scanView.dart';
import 'package:wms_app/widgets/wmsLoadingPage.dart';
import 'package:async/async.dart';

// https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2

class ScanPage extends StatefulWidget {
  final AsyncMemoizer<CameraView> _memoizer = AsyncMemoizer();

  final void Function(String product) onSuccesfullScan;
  Transition imageContent;
  // seems to need same type: https://stackoverflow.com/questions/62731654/flutter-combine-multiple-futuret-tasks
  //FutureGroup<>

  Product
      product; // should probably not be here, but 'wmsstacked' image content needs it
  ScanPage(this.onSuccesfullScan, this.imageContent, this.product);

  @override
  _State createState() => _State();
}

class _State extends State<ScanPage> {
  WorkStore workStore = WorkStore.instance;
  //MediaQueryData mediaQueryData;
  // Future<Sequence> sequence;
  Future<CameraView>? cameraViewFuture;

  String ean = "";

  @override
  void initState() {
    this.cameraViewFuture = this.widget._memoizer.runOnce(() => CameraView());
    super.initState();
  }

  // alls pages should have future builder, more or less
  FutureBuilder futureBuilder() => FutureBuilder<CameraView>(
      future: this.cameraViewFuture,
      builder: (BuildContext context, AsyncSnapshot<CameraView> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }
        //return page(snapshot.data);
        return page(snapshot.data ?? Container());
      });
  // conditional renderering, searchView
  Widget page(Widget cameraView) {
    return Scaffold(
        //appBar: WMSAppBar(this.widget.name).get(),
        body: Column(children: [
          Expanded(
              flex: 9,
              child: WMSStacked(cameraView,
                  this.widget.imageContent(this.widget.product, ean))),
          Expanded(
              flex: 7,
              child: ScanView((String barcode) {
                this.ean = barcode;
                this.widget.onSuccesfullScan(barcode);
              }))
        ] // camera view part of page and recontructed on 'scannedProducts' state change
            ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset:
            false); // https://stackoverflow.com/questions/49840074/keyboard-pushes-the-content-up-resizes-the-screen
  }
  // animate scanview height changes..?

  @override
  Widget build(BuildContext context) {
    print("scanPage build");
    return futureBuilder();
  }

  // some sort of view that shows db sku suggestions, from image local sku.
  /*
  Widget productView(Product product) {
    return ProductView(product);
  }
  */
}