// ui test for 'featurePage', potentially use some dependency inject to keep pages, and mock it
// features.. should given/registered, and not contain widget imports..
import 'package:flutter/material.dart';
import 'package:wms_app/pages/prototypes/plockPageForwardList.dart';
import 'package:wms_app/pages/prototypes/plockPageIdeal.dart';

class Features {
  static List<Feature> _modes = [
    Feature("Plock-FramåtLista", PlockPageForwardList()),
    Feature("Plock-Ideal", PlockPageIdeal()),
    Feature("Inventering"),
    Feature("Tidsstatistik"),
    Feature("Mätning"),
    Feature("Mock1"),
    Feature("Mock2")
  ];
  static List<Feature> get() {
    return _modes;
  }
}

class Feature {
  String name;
  Widget widget;
  Feature(String name, [Widget widget]) {
    this.name = name;
    this.widget = widget == null ? defaultWidget(name) : widget;
  }

  Widget defaultWidget(String name) {
    return Scaffold(body: Center(child: Text(name)));
  }
}
