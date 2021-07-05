import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wms_app/views/productView.dart';

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

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
    return Container(
        child: (Column(children: [
      Expanded(child: _buildQrView(context) /*top()*/),
      Expanded(child: productView())
    ])));
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
            left: 0, top: 0 /*statusBarHeight*/, right: 0, bottom: 0));
  }

  // https://pub.dev/packages/qr_code_scanner/example
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      print("scanData: " + scanData?.code);
      setState(() {
        result = scanData;
      });
    });
  }

// to get hot reload to work
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget productView() {
    var collectProduct = collectStore.collect.current;
    return ProductView(collectProduct);
  }

  void scan() {
    print("scan");
  }
}
