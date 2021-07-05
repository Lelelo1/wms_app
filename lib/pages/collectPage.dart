import 'package:flutter/material.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/widgets/WMSAppBar.dart';

import 'AbstractPage.dart';

class CollectPage extends StatefulWidget implements AbstractPage {
  @override
  _State createState() => _State();

  final String name;

  CollectPage(this.name);
}

class _State extends State<CollectPage> {
  CollectStore collectStore = AppStore.injector.get<CollectStore>();
  MediaQueryData mediaQueryData;

  @override
  void initState() {
    super.initState();
    // restart collect iterarotor when entering protypes
    collectStore.collect = collectStore.productItems.iterator;
    collectStore.collect.moveNext();
  }

  @override
  Widget build(BuildContext context) {
    //print("barcode is: " + result?.)

    if (mediaQueryData == null) {
      mediaQueryData = MediaQuery.of(context);
    }
    return Scaffold(
        appBar: WMSAppBar(this.widget.name).get(),
        body: Container(
            child: (Column(children: [
          Expanded(child: CameraView() /*top()*/),
          Expanded(child: productView())
        ]))),
        extendBodyBehindAppBar: true);
  }

/*
  Widget top() {
    var topHeightFactor = 0.31;
    var topHeight = mediaQueryData.size.height * topHeightFactor;
    var statusBarHeight = mediaQueryData.padding.top;

    var buttonWidthFactor = 0.65;
    var buttonWidth = mediaQueryData.size.width * buttonWidthFactor;
    var buttonHeightFactor = 0.08;
    var buttonHeight = mediaQueryData.size.height * buttonHeightFactor;

    return Container(
        child: Center(
          child: SizedBox(
            child: MaterialButton(
                child: Icon(Icons.qr_code),
                onPressed: scan,
                color: Color.fromARGB(180, 133, 57, 227),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0),
            width: buttonWidth,
            height: buttonHeight,
          ),
        ),
        color: Colors.white,
        height: topHeight,
        margin: EdgeInsets.only(
            left: 0, top: 0 /*statusBarHeight*/, right: 0, bottom: 0));
  }
*/
  Widget productView() {
    var collectProduct = collectStore.collect.current;
    return ProductView(collectProduct);
  }

  void scan() {
    print("scan");
  }
}
