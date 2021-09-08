import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

// some of this comes from the sample of the 'flutter_google_ml_vision' github repo
// https://github.com/brianmtully/flutter_google_ml_vision/blob/master/LICENSE
// see license file in same folder as thsi file.

// about rotation there was initially an enum, with 0, 90 180 270,
// I am just assuming image rotation is 0 at all times

class VisionService {
  static VisionService _instance;
  static VisionService getInstance() {
    if (_instance == null) {
      _instance = VisionService();
    }
    return _instance;
  }

  BarcodeDetector _barcodeDetector = GoogleVision.instance.barcodeDetector();

  Future<String> analyzeBarcodeFromFilePath(String imagePath) async {
    var barcodes = await _barcodeDetector
        .detectInImage((GoogleVisionImage.fromFilePath(imagePath)));

    return toBarcodeString(barcodes);
  }

  Future<String> analyzeBarcodeFromBytes(Uint8List concatenatedPlanes,
      GoogleVisionImageMetadata imageMetaData) async {
    var barcodes = await _barcodeDetector.detectInImage(
        GoogleVisionImage.fromBytes(concatenatedPlanes, imageMetaData));

    return toBarcodeString(barcodes);
  }

  String toBarcodeString(List<Barcode> barcodes) {
    // need to know more about lists to make cleaner code below
    try {
      return barcodes[0]?.rawValue;
    } catch (Exception) {
      return '';
    }
  }
}
