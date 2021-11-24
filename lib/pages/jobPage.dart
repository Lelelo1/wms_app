import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/abstractPage.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils.dart';

class JobPage extends StatefulWidget implements AbstractPage {
  final workStore = WorkStore.instance;

  JobPage(this.name);

  @override
  State<StatefulWidget> createState() => _State();

  @override
  String name;
}

class _State extends State<JobPage> {
  @override
  Widget build(BuildContext context) => ScanPage(this.successfullScan);
  // probably need to make fade and do transperency within SearchView component to make it
  // appear/dissapear and use Stack here oustide of it

  // potentially move to 'view' folder
  Widget blurView(Widget view) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
      child: Container(
        child: view,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.10)),
      ));
  void successfullScan(String barcode) async {
    print("Successfull scaaaan!: " + barcode);

    var product = await this.widget.workStore.product(barcode);
    print(await product.futureToString());
    if (product.exists()) {
      // preform other job

      return;
    }

    print("navigate to SearchPage");
    // using 'pushReplacement' otherwise there are two renders of SearchProductView's: https://stackoverflow.com/questions/59457306/flutter-navigation-reopen-page-instead-of-pushing-it-again
    //Navigator.of(context).pushReplacement(();

    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => blurView(
                  Opacity(
                      child: SearchPage(
                          "search", barcode, closeSearchView, preformJob),
                      opacity: 0.94), //0.96
                ),
            opaque: false));
    /*
    Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) =>
                ;
                */
  }
}

// previously have tried SwitchTranstion to change widget inside with when doing view transition