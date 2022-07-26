import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';

import 'types.dart';

// IS THIS USED?? WHy is there 2 utils files?
typedef Scan = String;
typedef QR = String;

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

  static int defaultInt(int? value) => value ?? 0;
  static double defaultDouble(double? value) => value ?? 0;

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

  static T getAndDefaultAs<T>(Object? obj, T defaultTo) {
    //print(obj.toString() + " type: " + obj.runtimeType.toString());
    return obj == null ? defaultTo : obj as T;
  }

  static int? toNullableInt(String? s) {
    if (s == null) {
      return null;
    }
    return int.parse(s);
  }
}

extension IterableExtensions<T> on Iterable<T> {
  T find(bool Function(T t) comparer, T t) =>
      this.firstWhere(comparer, orElse: () => t);
}

extension StringExtensions on String {
  String append(String string) => this + string;

  String prepend(String string) => string + this;
}

extension NullableStringExtensions on String? {
  bool isNullOrEmpty() => this == null || this == "";
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

extension StatefulWidgetExtensions on State {
  Size screenSize() => MediaQuery.of(this.context).size;
}

extension SizeExtensions on Size {
  Size modified(double h) => new Size(this.width, this.height * h);
}

extension ScanExtension on Scan {
  String toShelf(String prefix) => this.replaceAll(prefix, "");
}

extension IteratorExtension<T> on Iterator<T> {
  List<T> toList() {
    List<T> items = [];
    while (this.moveNext()) {
      items.add(this.current);
    }
    return items;
  }
}

extension DatabaseExtension on IResultSet {
  List<Model> toModels() {
    var cols = this.cols.toList();
    var rows = this.rows.toList();

    if (cols.length == 0 || rows.length == 0) {
      return List.empty();
    }

    List<Model> models = List.empty(growable: true);

    for (var i = 0; i < this.numOfRows; i++) {
      Model map = {};
      for (var j = 0; j < this.numOfColumns; j++) {
        var name = cols[j].name;
        var value = rows[i].colAt(j);
        map[name] = value;
      }
      models.add(map);
    }

    return models;
  }
}
