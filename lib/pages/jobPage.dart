import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/abstractPage.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/scrollable.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsScaffold.dart';

typedef Content = Widget Function([Product p, String ean]);

class JobPage extends StatefulWidget implements AbstractPage {
  final workStore = WorkStore.instance;
  // in the order they are shown
  final Content overlayRoute; //bool instead
  final Content fadeRoute;
  final Content scrollRoute;

  JobPage(this.name, this.overlayRoute, this.fadeRoute, this.scrollRoute);

  @override
  State<StatefulWidget> createState() => _State();

  @override
  String name;
}

class _State extends State<JobPage> {
  Product product = Product.empty();
  // note that can't rerender color in app bar without rerender the rest of the app...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(this.widget.name, Color.fromARGB(255, 194, 66, 245),
                Colors.transparent, Colors.white)
            .get(),
        extendBodyBehindAppBar: true,
        body: WMSScrollable(content(), this.widget.scrollRoute(this.product)));

    //return WMSScaffold(this.widget.name, Color.fromARGB(255, 194, 66, 245))
    //    .get(WMSScrollable(content(), this.widget.scrollRoute(this.product)));
  }

  // ScanPage should take primiryContent thet is displayed in the cameraview

  Widget content() => ScanPage(this.successfullScan);

  void successfullScan(String barcode) async {
    print("Successfull scaaaan!: " + barcode);

    var product = await this.widget.workStore.product(barcode);
    print(await product.futureToString());

    setState(() {
      this.product = product; // should always reflect the resulting scan
    });

    fadeTransition(this.widget.fadeRoute(product));
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
