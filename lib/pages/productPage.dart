import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/jobPage.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';

import '../utils.dart';
import 'abstractPage.dart';

class ProductPage extends StatefulWidget implements AbstractPage {
  final String name;
  final Job job;
  final workStore = AppStore.injector.get<WorkStore>();

  ProductPage(this.name, this.job);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductPage> {
  PageController pageController = PageController();
  Product product;

  // make a WMSScaffold and reuse
  @override
  Widget build(BuildContext context) {
    //pageController = PageController()
    return Scaffold(
        appBar: WMSAppBar(this.widget.name).get(),
        body: PageView(
          controller: pageController,
          children: renderContent(),
          scrollDirection: Axis.vertical,
        ),
        extendBodyBehindAppBar: true);
  }

  List<Widget> renderContent() =>
      [ScanPage(scannedEAN), Center(child: Text("produkt information"))];

  Future<AbstractProduct> getProduct(String ean) =>
      this.widget.workStore.warehouseSystem.getProduct(ean);
  void scannedEAN(String ean) {
    this.product = Product(111111111);
    pageController.animateToPage(1,
        duration: Duration(milliseconds: 600),
        curve: Curves.decelerate); // find nice curve
  }

  Widget placeholder(String ean) => Center(child: Text(ean));
}
