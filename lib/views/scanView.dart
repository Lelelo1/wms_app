// partially made for debugging scanning
import 'package:flutter/material.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
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

  Product scannedProduct;

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
    return Column(children: this.isEnlarged ? searchContent() : scanContent());
  }

  List<Widget> scanContent() => [header(), scanButton(), ...scannedProducts()];

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

  List<Widget> searchContent() => [searchTitleArea(), textField()];

  Widget searchTitleArea() {
    return Stack(children: [closeButton(), stack()]);
  }

  double titleHeight = 80;
  Widget stack() {
    return Container(
        child: Row(
            children: [Text("10982782753", style: TextStyle(fontSize: 28))],
            mainAxisAlignment: MainAxisAlignment.center),
        height: this.titleHeight);
  }

  Widget closeButton() {
    return Container(
        child: Row(children: [
          MaterialButton(
              onPressed: () {
                setState(() {
                  this.isEnlarged = false;
                });
              },
              child: Icon(Icons.close),
              minWidth: 40)
        ], mainAxisAlignment: MainAxisAlignment.start),
        height: this.titleHeight);
  }

  // enter to sku to match it with the ean code that where scanned, select item in the list
  // TextFormField...?
  Widget textField() {
    return TextField(
        decoration: InputDecoration(
            border: InputBorder.none, hintText: 'Ange artikelnummer'));
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

  void gotBarcode(String barcode) async {
    print("got barcode: " + barcode);

    CameraViewController.scanningSuccessfull();
    this.scannedProduct = await IdentifyJob.scanned(barcode);

    setState(() {
      this.scannedBarcodes = [...this.scannedBarcodes, barcode];
      this.isEnlarged = !Utils.hasValue(this.scannedProduct);
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
