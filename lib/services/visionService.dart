import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:wms_app/utils.dart';
import 'dart:math';

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
  TextRecognizer _textDetector = GoogleVision.instance.textRecognizer();

  Future<String> analyzeBarcodeFromFilePath(String imagePath) =>
      extractBarcode(GoogleVisionImage.fromFilePath(imagePath));

  Future<String> analyzeBarcodeFromBytes(Uint8List concatenatedPlanes,
          GoogleVisionImageMetadata imageMetaData) =>
      extractBarcode(
          GoogleVisionImage.fromBytes(concatenatedPlanes, imageMetaData));

  Future<String> extractBarcode(GoogleVisionImage googleImage) async {
    /*
    VisionText visionText;
    try {
      visionText = await _textDetector.processImage(googleImage);
    } catch (exc) {
      print(
          "failed to proccess image and and extract barcode from the visionText result: " +
              exc.toString());
    }

    String barcode = extractBarcodeFromText(visionText);
    
    if (Utils.hasValue(barcode)) {
      return barcode;
    }
    */
    return (toBarcodeString(await _barcodeDetector.detectInImage(googleImage)));
  }

  String toBarcodeString(List<Barcode> barcodes) {
    // need to know more about lists to make cleaner code below
    try {
      return barcodes[0]?.rawValue;
    } catch (Exception) {
      return '';
    }
  }

  String extractBarcodeFromText(VisionText visionText) {
    // shorten somehow...?
    if (visionText == null ||
        visionText.blocks == null ||
        visionText.blocks.isEmpty) {
      return null;
    }
    List<TextBlock> blocks = List<TextBlock>.from(visionText.blocks)
        .where((element) => element != null)
        .toList(); // https://stackoverflow.com/questions/59439109/flutter-dart-cannot-modify-an-unmodifiable-list-occurs-when-trying-to-sort-a-l
    // for some reason I need to remove null values in the list...: https://stackoverflow.com/questions/66896648/how-to-convert-a-liststring-to-liststring-in-null-safe-dart
    // ... https://stackoverflow.com/questions/58385998/dart-flutter-max-value-from-list-of-objects
    print("blocks count: " + blocks.length.toString());
    blocks.sort((a, b) => Utils.defaultZero(a.confidence)
        .compareTo(Utils.defaultZero(b.confidence)));
    print("confidences of the text where...");
    blocks.forEach((element) {
      print("confidence " + element.confidence.toString());
    });

    return visionText.blocks[0].text;
  }
}
