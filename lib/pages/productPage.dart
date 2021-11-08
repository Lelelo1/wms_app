import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/jobPage.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsLabel.dart';
import 'package:wms_app/widgets/wmsPrintableState.dart';
import 'package:wms_app/widgets/wmsScaffold.dart';
import 'package:mobx/mobx.dart';
import '../utils.dart';
import 'abstractPage.dart';
import 'package:line_icons/line_icons.dart';

// ignore: must_be_immutable
class ProductPage extends StatefulWidget implements AbstractPage {
  final String name;
  final Job job;
  final workStore = AppStore.injector.get<WorkStore>();

  final PageController pageController = PageController();

  ProductPage(this.name, this.job);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductPage> implements WMSPrintableState {
  @override
  void initState() {
    this.widget.pageController.addListener(updatePageIndex);
    super.initState();
  }

  @observable
  int pageIndex = 0;

  Product product;

  Color scanPageTitleColor = Colors.white;
  Color productInformationTitleColor = Colors.black;

  @override
  String stateToString() =>
      Utils.varStateToString("pageIndex", this.pageIndex) +
      ", " +
      Utils.varStateToString("product", this.product) +
      ", " +
      Utils.varStateToString("scanPageTitleColor", this.scanPageTitleColor) +
      ", " +
      Utils.varStateToString(
          "productInformationTitleColor", this.productInformationTitleColor);

  @override
  Widget build(BuildContext context) {
    return page();
  }

  Widget page() {
    return WMSScaffold(
            this.widget.name,
            Color.fromARGB(255, 194, 66,
                245) /*pageTitleColor(pageIndex)*/) // can't rerender app bar separetely in flutter. It requires whole scaffold (all content) to rerender, unless memoizing everything which should not be done to content that are specific to ProductPage there is no way of doing it
        .get(PageView(
      controller: this.widget.pageController,
      children: renderContent(),
      scrollDirection: Axis.vertical,
    ));
  }

  Color pageTitleColor(int p) {
    print("color: " + p.toString());
    return p > 0 ? productInformationTitleColor : scanPageTitleColor;
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
    if (this.pageIndex != page) {
      print("set page to: " + page.toString());
      this.pageIndex = page;
    }
  }

  List<Widget> renderContent() => [
        ScanPage(scannedEAN),
        Observer(builder: (_) {
          print("observer on product in product page: " +
              this.product.toString());
          return asyncProductView();
        })
      ];
  // Future.sync(() => "mockShelf")
  Widget asyncProductView() {
    print(
        "async widget: " + stateToString()); // renders 2 times for some reason
    return SafeArea(
        child: Column(children: [
      WMSAsyncWidget(this.product.getSKU(), (String sku) => Text(sku, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400))), //,
      WMSAsyncWidget(this.product.getEAN(), (String shelf) => WMSLabel(shelf, LineIcons.barcode)),
      WMSAsyncWidget(this.product.getShelf(), (String shelf) => Text(shelf)),
      WMSAsyncWidget(this.product.getName(), (String name) => Text(name)),
      //WMSAsyncWidget(this.product.getEAN(), (String name) => Text(name)), // barcode icon
      WMSAsyncWidget(Future.sync(() => this.product.id.toString()),
          (String id) => Row(children: [Icon(Icons.text_format), Text(id)]))
    ]));
  }


  Widget skuWidget(String sku) {
    return Row(children: [Ic],)
  }

  // sku:
  // id -> Icons.desktop_windows
  // ean -> LineIcons.barcode)
  // shelf -> Icon(LineIcons.warehouse // cound't find anny better...
  // (img)
  // Icon(Icons.text_format) // can be made better
  Future<AbstractProduct> getProduct(String ean) =>
      this.widget.workStore.product(ean);
  void scannedEAN(String ean) async {
    var product = await this.widget.workStore.product(ean);

    if (product == null) {
      // ignore scan
      print("could not find this product with ean in the warehouse system");
      return;
    }
    print("product id: " + product.id.toString());

    this.product = product;

    //product.setEAN(ean);

    //product.getShelf();

    //product.getSKU();

    print("animate to page one");
    this.widget.pageController.animateToPage(1,
        duration: Duration(milliseconds: 600),
        curve: Curves.decelerate); // find nice curve
  }

  Widget placeholder(String ean) => Center(child: Text(ean));
}
