import 'package:flutter/material.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/extended/stacked.dart';
import 'package:wms_app/views/scanView.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsLoadingPage.dart';
import 'package:async/async.dart';

// https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2

class ScanPage extends StatefulWidget {
  final AsyncMemoizer<CameraView> _memoizer = AsyncMemoizer();
  final Widget imageContent;

  ScanPage(this.imageContent);

  @override
  _State createState() => _State();
}

class _State extends State<ScanPage> {
  //MediaQueryData mediaQueryData;
  // Future<Sequence> sequence;
  Future<CameraView>? cameraViewFuture;

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
              flex: 9, child: WMSStacked(cameraView, this.widget.imageContent)),
          Expanded(flex: 7, child: ScanView())
        ] // camera view part of page and recontructed on 'scannedProducts' state change
            ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset:
            false); // https://stackoverflow.com/questions/49840074/keyboard-pushes-the-content-up-resizes-the-screen
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
  void fadeTransition(Widget searchRoute) {
    if (searchRoute is WMSEmptyWidget) {
      return;
    }

    Navigator.push(
        context, PageRouteBuilder(pageBuilder: (_, __, ___) => searchRoute));
  }
}
