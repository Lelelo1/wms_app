import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/AbstractPage.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/utils.dart';

class JobPage extends StatefulWidget implements AbstractPage {
  final Job job;

  JobPage(this.job);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JobPage> {
  @override
  Widget build(BuildContext context) =>
      ScanPage(this.widget.job.name, this.successfullScan);
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

    var product = await this.widget.job.identify(barcode);
    if (Utils.hasValue(product)) {
      // preform other job
      return;
    }

    Navigator.of(context).push(PageRouteBuilder(
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

  void closeSearchView() {} // not needed ?

  void preformJob(Product product) async {
    var productName = await product.getName();
    var productId = product.id;
    print("preform job " +
        this.widget.job.name +
        " with product" +
        productName +
        " id: " +
        productId.toString());
  }
}

// previously have tried SwitchTranstion to change widget inside with when doing view transition