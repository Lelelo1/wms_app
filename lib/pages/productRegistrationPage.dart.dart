import 'package:flutter/material.dart';
import 'package:wms_app/pages/AbstractPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/widgets/WmsAppBar.dart';

class ProductRegistrationPage extends StatefulWidget implements AbstractPage {
  @override
  State<StatefulWidget> createState() => _State();

  @override
  final String name;

  ProductRegistrationPage(this.name);

  // just to display an arbitary item
  final testProduct = AppStore.injector.get<CollectStore>().productItems[0];
}

class _State extends State<ProductRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(this.widget.name).get(),
        body: Container(
            child: (Column(children: [
          Expanded(child: CameraView() /*top()*/),
          Expanded(child: ProductView(this.widget.testProduct))
        ]))),
        extendBodyBehindAppBar: true);
  }
}
