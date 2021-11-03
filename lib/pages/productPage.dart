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
import 'package:wms_app/widgets/wmsScaffold.dart';

import '../utils.dart';
import 'abstractPage.dart';

class ProductPage extends StatefulWidget implements AbstractPage {
  final String name;
  final Job job;
  final workStore = AppStore.injector.get<WorkStore>();

  final PageController pageController = PageController();

  ProductPage(this.name, this.job);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductPage> {
  Product product;

  Color scanPageTitleColor = Colors.white;
  Color productInformationTitleColor = Colors.black;

  int pageIndex = 0;

  @override
  initState() {
    this.widget.pageController.addListener(updatePageIndex);
    super.initState();
  }

  Color pageTitleColor() {
    return pageIndex > 0 ? productInformationTitleColor : scanPageTitleColor;
  }

  bool shouldExtendPageContent() => pageIndex == 0 ? true : false;

  int currentPage() {
    var p = this.widget.pageController.page;
    if (p > 0.5) {
      return 1;
    } else {
      return 0;
    }
  }

  void updatePageIndex() {
    var page = currentPage();
    setState(() {
      if (this.pageIndex != page) {
        print("setState: " + page.toString());
        this.pageIndex = page;
      }
    });
  }

  // make a WMSScaffold and reuse
  @override
  Widget build(BuildContext context) {
    //pageController = PageController()

    return WMSScaffold(widget.name, pageTitleColor()).get(PageView(
      controller: this.widget.pageController,
      children: renderContent(),
      scrollDirection: Axis.vertical,
    ));

    /*
    return Scaffold(
        appBar: WMSAppBar(widget.name, pageTitleColor()).get(),
        body: PageView(
          controller: this.widget.pageController,
          children: renderContent(),
          scrollDirection: Axis.vertical,
        ),
        extendBodyBehindAppBar: true);
        */
  }

  List<Widget> renderContent() => [ScanPage(scannedEAN)];

  Widget asyncProductView() => this.product == null
      ? Container()
      : WMSAsyncWidget(
          this.product?.getShelf(),
          (shelf) => SafeArea(
                child: Column(children: [
                  Text(shelf),
                ]),
              ));

  Future<AbstractProduct> getProduct(String ean) =>
      this.widget.workStore.product(ean);
  void scannedEAN(String ean) async {
    var product = await this.widget.workStore.product(ean);

    if (product == null) {
      // ignore scan
      print("could not find this product with ean in the warehouse system");
      return;
    }

    product.setEAN(ean);

    product.getShelf();

    //product.getSKU();
    print("animate to page one");
    this.widget.pageController.animateToPage(1,
        duration: Duration(milliseconds: 600),
        curve: Curves.decelerate); // find nice curve
  }

  Widget placeholder(String ean) => Center(child: Text(ean));
}
