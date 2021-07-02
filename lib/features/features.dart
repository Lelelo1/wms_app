// ui test for 'featurePage', potentially use some dependency inject to keep pages, and mock it
// features.. should given/registered, and not contain widget imports..
import 'package:flutter/material.dart';
import 'package:wms_app/pages/collectPage.dart';

class Features {
  static List<Feature> _modes = [
    /*Feature("Plock-FramåtLista", PlockPageForwardList()),*/
    Feature("Plock", CollectPage()),
    Feature("Inventering"),
    Feature("Tidsstatistik"),
    Feature("Mätning"),
    Feature(
        "Lägg in streckkoder"), // it should probably be renamed, as collecting also uses scanning. should probably be named 'register product'
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
