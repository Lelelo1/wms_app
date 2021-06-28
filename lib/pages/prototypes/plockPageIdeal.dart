import 'package:flutter/material.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/plockStore.dart';
import 'package:wms_app/views/adaptiveProductView.dart';

class PlockPageIdeal extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<PlockPageIdeal> {
  PlockStore plockStore = AppStore.injector.get<PlockStore>();
  MediaQueryData mediaQueryData;
  @override
  void initState() {
    super.initState();
    plockStore.collect.moveNext();
  }

  @override
  Widget build(BuildContext context) {
    if (mediaQueryData == null) {
      mediaQueryData = MediaQuery.of(context);
    }
    return Container(child: Column(children: [top(), productView()]));
  }

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
            left: 0, top: statusBarHeight, right: 0, bottom: 0));
  }

  Widget productView() {
    var collectProduct = plockStore.collect.current;
    return AdaptiveProductView(); //ProductView(collectProduct);
  }

  void scan() {
    print("scan");
  }
}
