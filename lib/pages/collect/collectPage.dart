import 'package:flutter/material.dart';
import 'package:wms_app/content/transitions.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/services/scanHandler.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// can I used state and the setState call with product in 'StatelessWidget'
// ignore: must_be_immutable
class CollectPage extends WMSPage {
  @override
  final String name = "Plock";

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CollectPage> {
  // note that can't rerender color in app bar without rerender the rest of the app...

  @override
  void initState() {
    WorkStore.instance.assignShelfEvent.subscribe((args) async {
      var product = WorkStore.instance.currentProduct;
      var productName = await product.getName();
      var shelf = WorkStore.instance.currentShelf;
      Alert(
          context: this.context,
          desc:
              "Vill du lägga till hyllplatsen $shelf till produkten $productName",
          buttons: [
            DialogButton(
              onPressed: () async {
                await WSInteract.remoteSql(WorkStore.instance.queries
                    .setShelf(product.id.toString(), shelf));
                ScanHandler.handleScanResult(ScanHandler.shelfPrefix + shelf);
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
