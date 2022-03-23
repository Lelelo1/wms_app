import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/services/scanHandler.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsImageContent.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsTransitions.dart';
import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../utils.dart';

// can I used state and the setState call with product in 'StatelessWidget'
// ignore: must_be_immutable
class ReturnPage extends WMSPage {
  @override
  String name = "Retur";

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReturnPage> {
  // note that can't rerender color in app bar without rerender the rest of the app...

  @override
  void initState() {
    WorkStore.instance.assignShelfEvent.subscribe((args) async {
      var productName = await WorkStore.instance.currentProduct.getName();
      var shelf = WorkStore.instance.currentShelf;
      Alert(
          context: this.context,
          desc:
              "Vill du lägga till hyllplatsen $shelf till produkten $productName",
          buttons: [
            DialogButton(
              onPressed: () {
                // post shelf to product
                ScanHandler.scan(shelf);
                Navigator.pop(context);
              },
              child: Text("Ja"),
            ),
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Nej"),
            )
          ]).show();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(this.widget.name, Color.fromARGB(255, 194, 66, 245),
                Colors.transparent, Colors.white)
            .get(),
        extendBodyBehindAppBar: true,
        body: EventSubscriber(
            event: WorkStore.instance.productEvent,
            handler: (_, __) {
              var product = WorkStore.instance.currentProduct;
              var productView =
                  product.exists() ? ProductRoute(product) : WMSEmptyWidget();
              var imageContent = Transitions.imageContent(fadeContent);
              var scrollable =
                  WMSScrollable(ScanPage(imageContent), productView);

              return scrollable;
            }));
  }

  void fadeContent() async {
    var product = WorkStore.instance.currentProduct;
    var ean = WorkStore.instance.currentEAN;
    print("fadeContent!!");
    if (product.exists() || Utils.isNullOrEmpty(ean)) {
      return;
    }
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                SearchRoute(SearchPage(product, ean))));
  }
}

// previously have tried SwitchTranstion to change widget inside with when doing view transition
