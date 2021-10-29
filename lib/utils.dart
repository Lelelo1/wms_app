import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:mysql1/mysql1.dart';

class Utils {
  // for better readability, there is a javascript
  // library I forgot the name of, that contains
  // these small methods, have not found one for flutter (yet)
  static bool hasValue<T>(T value) {
    return value != null;
  }

  static bool isNullOrEmpty<T>(T t) {
    if (t == null) {
      return true;
    }

    // check is empty
    if (t is String) {
      return t.isEmpty;
    } else if (t is ListBase) {
      return t.isEmpty;
    } else if (t is Results) {
      return t.isEmpty;
    }
    throw Exception(
        "Utils isNullOrEmpty is not supperted for type " + T.toString());
  }

  // https://stackoverflow.com/questions/55579906/how-to-count-items-occurence-in-a-list
  static Map occurence<T>(List<T> list) {
    var map = Map();
    list.forEach((x) => map[x] = !map.containsKey(x) ? (1) : (map[x] + 1));
    return map;
  }

  // same of primitive types in other programming languages
  static double defaultZero<T extends double>(T value) =>
      value == null ? 0 : value;
}

class ImageUtils {
  static GoogleVisionImageMetadata imageData(CameraImage image) =>
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

  static Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }
}
