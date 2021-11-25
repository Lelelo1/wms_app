import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/abstractPage.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/views/scrollable.dart';
import 'package:wms_app/widgets/wmsScaffold.dart';

class JobPage extends StatefulWidget implements AbstractPage {
  final workStore = WorkStore.instance;
  final Widget Function(Product product) overlayRoute;
  final ProductRoute Function(Product product) scrollRoute;
  final SearchRoute Function(String barcode) fadeRoute;

  JobPage(this.name, this.overlayRoute, this.scrollRoute, this.fadeRoute);

  @override
  State<StatefulWidget> createState() => _State();

  @override
  String name;
}

class _State extends State<JobPage> {
  Product product = Product.empty();

  @override
  Widget build(BuildContext context) {
    return WMSScaffold(
            this.widget.name,
            Color.fromARGB(255, 194, 66,
                245) /*pageTitleColor(pageIndex)*/) // can't rerender app bar separetely in flutter. It requires whole scaffold (all content) to rerender, unless memoizing everything which should not be done to content that are specific to ProductPage there is no way of doing it
        .get(WMSScrollable(content(), this.widget.scrollRoute(product)));
    //ScanPage(this.successfullScan);
  }

  Widget content() => ScanPage(this.successfullScan);

  void successfullScan(String barcode) async {
    print("Successfull scaaaan!: " + barcode);

    var product = await this.widget.workStore.product(barcode);
    print(await product.futureToString());
    if (product.exists()) {
      // preform other job

      return;
    }

    print("navigate to SearchPage");
    /*
    Navigator.push(
        context,
        ;
        */
  }
}

 
// previously have tried SwitchTranstion to change widget inside with when doing view transition