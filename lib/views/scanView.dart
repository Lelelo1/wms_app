// partially made for debugging scanning
import 'package:flutter/material.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/views/cameraView.dart';
import '../utils.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ScanView extends StatefulWidget {
  double ratio;

  void Function(String barcode) scanned;

  ScanView(this.ratio, this.scanned);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ScanView> {
  List<String> scannedBarcodes = [];
  Size currentSize = Size.zero;

  Size defaultSize = Size.zero;
  Size enlargedSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    if (!hasCalculatedSizes()) {
      calculateSizes();
    }
    return Container(child: scanContent(), height: 320);
  }

  Column scanContent() =>
      Column(children: [/*header(),*/ scanButton(), ...scannedProducts()]);
  /*
  Widget header([String shelf = "D-3-2-C"]) {
    return Container(
        child: Center(child: Text(shelf, style: TextStyle(fontSize: 30))),
        color: Colors.white);
  }
  */
  Widget scanButton() {
    return Padding(
        child: Container(
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
            height: 65),
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
    var visionSevice = VisionService.instance;
    String barcode;
    var streamImage = CameraViewController.streamImage;
    if (streamImage != null) {
      barcode = await visionSevice.analyzeBarcodeFromBytes(
          ImageUtils.concatenatePlanes(streamImage.planes),
          ImageUtils.imageData(streamImage));
    } else {
      barcode = await visionSevice.analyzeBarcodeFromFilePath(
          (await CameraViewController.takePhoto()).path);
    }

    if (Utils.isNullOrEmpty(barcode)) {
      return;
    }

    gotBarcode(barcode);
    // need error handling...
  }

  void gotBarcode(String barcode) async {
    print("got barcode: " + barcode);

    CameraViewController.scanningSuccessfull();

    setState(() {
      this.scannedBarcodes = [...this.scannedBarcodes, barcode];
    });

    this.widget.scanned(barcode);
    // what should be shown in the scanview, what should be gotten, depending on which Job
  }

  bool hasCalculatedSizes() =>
      Utils.hasValue(this.defaultSize) && Utils.hasValue(this.enlargedSize);

  void calculateSizes() {
    var screenSize = MediaQuery.of(this.context).size;
    this.defaultSize =
        Size(screenSize.width, screenSize.height * this.widget.ratio);
  }

  Size getSize() => this.defaultSize;
}
