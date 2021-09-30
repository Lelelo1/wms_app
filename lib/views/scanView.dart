// partially made for debugging scanning
import 'package:flutter/material.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/views/cameraView.dart';

import '../utils.dart';

class ScanView extends StatefulWidget {
  ScanView(this.defaultRatio, this.enlargedRatio);

  @override
  State<StatefulWidget> createState() => _State();

  double defaultRatio;
  double enlargedRatio;
}

class _State extends State<ScanView> {
  List<String> scannedBarcodes = [];
  Size currentSize;

  bool isEnlarged = false;

  Size defaultSize;
  Size enlargedSize;

  @override
  Widget build(BuildContext context) {
    if (!hasCalculatedSizes()) {
      calculateSizes();
    }
    var size = getSize();
    print("siiize: " + size.toString());

    return Container(child: column(), width: size.width, height: size.height);
  }

  Widget column() {
    return Column(children: [header(), scanButton(), ...scannedProducts()]);
  }

  Widget header([String shelf = "D-3-2-C"]) {
    return Container(
        child: Center(child: Text(shelf, style: TextStyle(fontSize: 30))),
        color: Colors.white);
  }

  Widget scanButton() {
    return ElevatedButton(onPressed: scan, child: Text("Scanna"));
  }

  List<Widget> scannedProducts() {
    if (this.scannedBarcodes?.length == 0) {
      return [Container()];
    }

    var occurrences = Utils.occurence(this.scannedBarcodes);
    return Utils.occurence(this.scannedBarcodes)
        .keys
        .map((b) => Text(b + ": " + occurrences[b].toString()))
        .toList();
  }

  void scan() async {
    var visionSevice = VisionService.getInstance();

    String barcode;
    var streamImage = CameraViewController.streamImage;
    if (Utils.hasValue(streamImage)) {
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

  void gotBarcode(String barcode) {
    print("got barcode: " + barcode);

    CameraViewController.scanningSuccessfull();

    setState(() {
      this.scannedBarcodes = [...this.scannedBarcodes, barcode];
    });

    setState(() {
      this.isEnlarged = !this.isEnlarged;
    });
  }

  bool hasCalculatedSizes() =>
      Utils.hasValue(this.defaultSize) && Utils.hasValue(this.enlargedSize);

  void calculateSizes() {
    var screenSize = MediaQuery.of(this.context).size;
    this.defaultSize =
        Size(screenSize.width, screenSize.height * this.widget.defaultRatio);
    this.enlargedSize =
        Size(screenSize.width, screenSize.height * this.widget.enlargedRatio);
  }

  Size getSize() => this.isEnlarged ? this.enlargedSize : this.defaultSize;
}
