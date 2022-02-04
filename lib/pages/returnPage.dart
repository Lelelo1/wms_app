import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/services/scanHandler.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsTransitions.dart';

// can I used state and the setState call with product in 'StatelessWidget'
// ignore: must_be_immutable
class ReturnPage extends WMSPage implements WMSTransitions {
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
  Product currentProduct = Product.empty();
  // note that can't rerender color in app bar without rerender the rest of the app...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(this.widget.name, Color.fromARGB(255, 194, 66, 245),
                Colors.transparent, Colors.white)
            .get(),
        extendBodyBehindAppBar: true,
        body: WMSScrollable(
            content(), this.widget.scrollContent()(this.currentProduct, "")));

    //return WMSScaffold(this.widget.name, Color.fromARGB(255, 194, 66, 245))
    //    .get(WMSScrollable(content(), this.widget.scrollRoute(this.product)));
  }

  // ScanPage should take primiryContent thet is displayed in the cameraview

  Widget content() => ScanPage(
      this.successfullScan, this.widget.imageContent(), this.currentProduct);

  void successfullScan(String scanData) async {
    print("Successfull scaaaan!: " + scanData);

    ScanHandler.handleScanData(scanData, this.currentProduct,
        (Product product) async {
      print("was barcode");
      print(await product.futureToString());
      setState(() {
        this.currentProduct =
            product; // should always reflect the resulting scan
      });

      fadeTransition(this.widget.fadeContent()(product, scanData));
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
