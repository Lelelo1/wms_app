import 'dart:ui';
import 'package:event/event.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/content/transitions.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/remote/warehouseSystem.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/services/scanHandler.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/widgets/wmsAlert.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsTransitions.dart';
import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../utils.dart';

class WMSPage extends StatelessWidget {
  Widget page = WMSEmptyWidget();

  WMSPage(this.page) {
    WorkStore.instance.assignShelfEvent.subscribe(assignShelfAlertTrigger);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
  }

  void assignShelfAlertTrigger(EventArgs? eventArgs) async {
    var product = WorkStore.instance.currentProduct;
    var productName = await product.getName();
    var shelf = WorkStore.instance.currentShelf;

    WMSAlert.get(context,
        "Vill du lägga till hyllplatsen $shelf till produkten $productName",
        () async {
      await WarehouseSystem.instance.setShelf(product, shelf);
    });
    ScanHandler.handleScanResult(ScanHandler.shelfPrefix + shelf);
    Navigator.pop(context);
  }
=======

abstract class WMSPage extends StatefulWidget {
  abstract final String name;
>>>>>>> b6950dab9bda66d44fce582e96c6a0f5b05211bd
}
