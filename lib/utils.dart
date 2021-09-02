import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

import 'models/image.dart';

class Utils {
  // for better readability, there is a javascript
  // library I forgot the name of, that contains
  // these small methods, have not found one for flutter (yet)
  static bool hasValue<T>(T value) {
    return value != null;
  }
}

class ImageUtils {
  static AbstractImage toAbstractImage(CameraImage image) =>
      AbstractImage(_imageData(image), _concatenatePlanes(image.planes));

  static GoogleVisionImageMetadata _imageData(CameraImage image) =>
      GoogleVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: ImageRotation.rotation0,
        planeData: image.planes
            .map((Plane plane) => GoogleVisionImagePlaneMetadata(
                  bytesPerRow: plane.bytesPerRow,
                  height: plane.height,
                  width: plane.width,
                ))
            .toList(),
      );

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }
}
