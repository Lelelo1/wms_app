import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

// some of this comes from the sample of the 'flutter_google_ml_vision' github repo
// https://github.com/brianmtully/flutter_google_ml_vision/blob/master/LICENSE
// see license file in same folder as thsi file.

class VisionService {
  static VisionService _instance;
  static VisionService getInstance() {
    if (_instance == null) {
      _instance = VisionService();
    }
    return _instance;
  }

  BarcodeDetector _barcodeDetector = GoogleVision.instance.barcodeDetector();

  Future<String> analyzeBarcode(CameraImage image, int imageRotation) async {
    var metadata =
        _buildMetaData(image, _rotationIntToImageRotation(imageRotation));

    var barcodes = await _barcodeDetector.detectInImage(
        GoogleVisionImage.fromBytes(
            _concatenatePlanes(image.planes), metadata));
    // don't know if 'first' is safe to use, need to find out
    try {
      return barcodes[0]?.rawValue;
    } catch (Exception) {
      return '';
    }
  }

  static GoogleVisionImageMetadata _buildMetaData(
    CameraImage image,
    ImageRotation rotation,
  ) {
    print("_buildMetaData aaa, image format: " + image?.format.raw.toString());
    return GoogleVisionImageMetadata(
      rawFormat: image.format.raw,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      planeData: image.planes.map(
        (Plane plane) {
          return GoogleVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  }

  static ImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      default:
        return ImageRotation.rotation270;
    }
  }

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }
}
