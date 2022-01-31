import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/widgets/WMSPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

// can I used state and the setState call with product in 'StatelessWidget'
// ignore: must_be_immutable
class ReturnPage extends WMSPage {
  @override
  Transition Function() imageContent = () => Transitions.imageContent;

  @override
  Transition Function() fadeContent = () => WMSPage.configuration == "dev"
      ? Transitions.fadeContent
      : Transitions.empty;

  @override
  Transition Function() scrollContent = () => WMSPage.configuration == "dev"
      ? Transitions.scrollContent
      : Transitions.empty;

  ReturnPage(String name) : super(name);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReturnPage> {
  Product product = Product.empty();
  // note that can't rerender color in app bar without rerender the rest of the app...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(this.widget.name, Color.fromARGB(255, 194, 66, 245),
                Colors.transparent, Colors.white)
            .get(),
        extendBodyBehindAppBar: true,
        body: WMSScrollable(
            content(), this.widget.scrollContent()(this.product, "")));

    //return WMSScaffold(this.widget.name, Color.fromARGB(255, 194, 66, 245))
    //    .get(WMSScrollable(content(), this.widget.scrollRoute(this.product)));
  }

  // ScanPage should take primiryContent thet is displayed in the cameraview

  Widget content() =>
      ScanPage(this.successfullScan, this.widget.imageContent(), this.product);

  void successfullScan(String scan) async {
    print("Successfull scaaaan!: " + scan);

    if (this.product.exists()) {
      shelfScan(scan);
      return;
    }

    barcodeScan(scan);
  }

  void barcodeScan(String barcode) async {
    var product = await WMSPage.workStore.product(barcode);
    print(await product.futureToString());

    setState(() {
      this.product = product; // should always reflect the resulting scan
    });

    fadeTransition(this.widget.fadeContent()(product, barcode));
  }

  void shelfScan(String scan) async {
    print("print shelf scan!!");
    var shelf = await this.product.getShelf();
    if (shelf == "-") {
      return; // prompt product not having assined shelf -> go to computer with product
    }

    if (scan != shelf) {
      return; // user scans wrong shelf, should probably do do nothing
    }

    setState(() {
      this.product = Product.empty();
    });
  }

  void fadeTransition(Widget searchRoute) {
    if (searchRoute is WMSEmptyWidget) {
      return;
    }

    Navigator.push(
        context, PageRouteBuilder(pageBuilder: (_, __, ___) => searchRoute));
  }
}

// previously have tried SwitchTranstion to change widget inside with when doing view transition
