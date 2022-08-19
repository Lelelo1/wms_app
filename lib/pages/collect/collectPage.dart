import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:wms_app/content/transitions.dart';
import 'package:wms_app/models/collectRoute.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/services/scanHandler.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
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
                ScanPage(this.imageContent(context), scan),
                ProductRoute(WorkStore.instance.currentProduct))));
  }

  void scan() async {
    var path = (await CameraViewController.takePhoto()).path;
    var scanResult = await ScanHandler.scan(path);
    if (scanResult == WorkStore.instance.currentProduct.ean) {
      CollectStore.instance.next();
    }
  }
/*
  @override
  Widget imageContent(BuildContext context) {
    var ean = WorkStore.instance.currentEAN;
    var p = WorkStore.instance.currentProduct;
    print("ppp: " + p.toString());
    Widget content =
        p.exists ? this.shelfWidget(p.shelf) : this.eanWidget(ean, context);

    return cameraContent(
        content, scanSymbol(MaterialCommunityIcons.barcode_scan), 10);
  }
*/
  //Widget boxWidget(String box) => if;

  Widget boxButton(Widget text) => ElevatedButton(
      onPressed: () {
        setState(() {});
      },
      child: text,
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0))),
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(200, 216, 230, 96))));
}

// previously have tried SwitchTranstion to change widget inside with when doing view transition
