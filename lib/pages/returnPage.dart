import 'package:flutter/material.dart';
import 'package:wms_app/content/transitions.dart';
import 'package:wms_app/models/abstractProduct.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// can I used state and the setState call with product in 'StatelessWidget'
// ignore: must_be_immutable
class ReturnPage extends WMSPage {
  @override
  final String name = "Retur";

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReturnPage> with Transitions {
  // note that can't rerender color in app bar without rerender the rest of the app...

  @override
  void initState() {
    WorkStore.instance.assignShelfEvent.subscribe((args) async {
      var product = WorkStore.instance.currentProduct;
      var productName = product.name;
      var shelf = WorkStore.instance.currentShelf;

      if (product.shelf == AbstractProduct.assignShelf) {
        Alert(
            context: this.context,
            desc:
                "Vill du lägga till hyllplatsen $shelf till produkten $productName",
            buttons: [
              DialogButton(
                onPressed: () async {
                  await product.setShelf(shelf);
                  await product.increaseQty();
                  WorkStore.instance.setReturn();
                  WorkStore.instance.assignShelfEvent.broadcast();
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
      }
    });

    WorkStore.instance.setReturn();

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
}

// previously have tried SwitchTranstion to change widget inside with when doing view transition
