import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

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

  // needed for null safety, just like primitives in other languages
  static String defaultString(String? value, [String to = '']) => value ?? to;
  static int defaultInt(int? value) => value ?? 0;
  static double defaultDouble(double? value) => value ?? 0;

  static List<String> defaultImages(List<String>? images,
          [List<String> to = const []]) =>
      images ?? to;

  // https://stackoverflow.com/questions/55579906/how-to-count-items-occurence-in-a-list
  static Map occurence<T>(List<T> list) {
    var map = Map();
    list.forEach((x) => map[x] = !map.containsKey(x) ? (1) : (map[x] + 1));
    return map;
  }

  static String varStateToString<T>(String variableName, T value) =>
      variableName + ": " + value.toString();

  static int toInt(double value) => value.round();

  static String listToString(List<String> list) {
    if (isNullOrEmpty(list)) {
      return "";
    }

    String s = "";
    list.forEach((e) => s += ", " + e);

    return s;
  }
  /*
  static String toString<T>(T t) {
    if (isNullOrEmpty(t)) {
      return "";
    }

    if (t is List) {
      // should catch all type of elements
      String s = "";
      t.forEach((e) => s += ", " + e);
      return s;
    }

    return s;
  }
  */

}

// needed beacuse of null safeety strings
// I actually don't think is needed, if I make sure 'String' is used everywhere instead of 'String?'
extension StringNullSafetyExtensions on String? {
  String append(String string) => Utils.defaultString(this) + string;

  String prepend(String string) => string + Utils.defaultString(this);

  String appendSafe(String? string) =>
      Utils.defaultString(this) + Utils.defaultString(string);

  String prependSafe(String? string) =>
      Utils.defaultString(string) + Utils.defaultString(this);
}

extension StringExtensions on String {
  String append(String string) => this + string;

  String prepend(String string) => string + this;

  String appendSafe(String? string) => this + Utils.defaultString(string);

  String prependSafe(String? string) => Utils.defaultString(string) + this;
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
/*
extension WidgetExtensions on Widget {
  void exists(void Function(Widget) exists) {
    if (Widget is WMSEmptyWidget) {
      return;
    }

    exists(this);
  }
}
*/

extension StatefulWidgetExtensions on State {
  Size screenSize() => MediaQuery.of(this.context).size;
}

extension SizeExtensions on Size {
  Size modified(double h) => new Size(this.width, this.height * h);
}
