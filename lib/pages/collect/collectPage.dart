import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:wms_app/content/transitions.dart';
import 'package:wms_app/models/product.dart';
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

class _State extends State<CollectPage> with Transitions {
  // note that can't rerender color in app bar without rerender the rest of the app...

  @override
  void initState() {
    WorkStore.instance.assignShelfEvent.subscribe((args) {
      var product = WorkStore.instance.currentProduct;

      var shelf = WorkStore.instance.currentShelf;
      Alert(
          context: this.context,
          desc: "Vill du lägga till hyllplatsen $shelf till produkten" +
              product.name,
          buttons: [
            DialogButton(
              onPressed: () async {
                /*
                await WSInteract.remoteSql(WorkStore.instance.queries
                    .setShelf(product.id.toString(), shelf));
*/
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

    WorkStore.instance.setCollect();

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
            handler: (context, __) => WMSScrollable(
                ScanPage(this.imageContent(context)),
                ProductRoute(WorkStore.instance.currentProduct))));
  }

  @override
  Widget imageContent(BuildContext context) {
    var ean = WorkStore.instance.currentEAN;
    var p = WorkStore.instance.currentProduct;

    Widget content =
        p.exists ? this.shelfWidget(p.shelf) : eanWidget(ean, context);

    return cameraContent(
        content, scanSymbol(MaterialCommunityIcons.barcode_scan));
  }
}

// previously have tried SwitchTranstion to change widget inside with when doing view transition
