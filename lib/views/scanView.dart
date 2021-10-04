// partially made for debugging scanning
import 'package:flutter/material.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/services/visionService.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/searchView.dart';

import '../utils.dart';

class ScanView extends StatefulWidget {
  double defaultRatio;
  double enlargedRatio;

  void Function() scanned;

  ScanView(this.defaultRatio, this.enlargedRatio, this.scanned);

  @override
  State<StatefulWidget> createState() => _State();
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
              onPressed: () {},
            ),
            width: 170,
            height: 65),
        padding: EdgeInsets.all(30));
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

  void gotBarcode(String barcode) async {
    print("got barcode: " + barcode);

    CameraViewController.scanningSuccessfull();
    this.scannedProduct = await IdentifyJob.scanned(barcode);

    setState(() {
      this.scannedBarcodes = [...this.scannedBarcodes, barcode];
      this.isEnlarged = !Utils.hasValue(this.scannedProduct);
    });

    // what should be shown in the scanview, what should be gotten, depending on which Job
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
