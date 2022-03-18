// partially made for debugging scanning
import 'package:flutter/material.dart';
import 'package:wms_app/services/scanHandler.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/views/cameraView.dart';
import '../utils.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ScanView extends StatefulWidget {
  ScanView();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ScanView> {
  List<String> scannedBarcodes = [];
  @override
  Widget build(BuildContext context) {
    return Container(child: scanContent(), height: 320);
  }

  Column scanContent() =>
      Column(children: [/*header(),*/ scanButton(), ...scannedProducts()]);

  Widget scanButton() {
    return Padding(
        child: Column(children: [
          Container(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0))),
                ),
                child: Text('Scanna'),
                onPressed: scan,
              ),
              width: 170,
              height: 65)
        ]),
        padding: EdgeInsets.all(30));
  }

  List<Widget> scannedProducts() {
    if (this.scannedBarcodes.isEmpty) {
      return [Container()];
    }

    var occurrences = Utils.occurence(this.scannedBarcodes);
    return Utils.occurence(this.scannedBarcodes)
        .keys
        .map((b) => Text(b + ": " + occurrences[b].toString()))
        .toList();
  }

  void scan() async {
    var path = (await CameraViewController.takePhoto()).path;
    var result = ScanHandler.scan(path);
    setState(() {
      
    });
  }

  void scanResult(String scanResult) {
    if (scanResult.isEmpty) {
      return;
    }

    CameraViewController.scanningSuccessfull();

    setState(() {
      this.scannedBarcodes = [...this.scannedBarcodes, scanResult];
    });
  }
}
