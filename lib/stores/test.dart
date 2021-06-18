// varplocklista
import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/plockPage.dart';

class Products {
  static List<Product> _products = [
    Product("Fantasie Swim", "A8", 19282718, 3, 12),
    Product("Fantasy baddräckt", "A9", 3923181, 3, 35),
    Product("Standard bikini", "A10", 32987653, 2, null),
    Product("Mönstrad vally kupa", "C1", 76523718, 1, 163),
    Product("Bikiniöverdel", "C3", 182382, 1, 127),
    Product("Katsumi classic", "C4", 1238493, 1, null),
    Product("Palm Vally", "D1", 1223874, 2, null),
    Product("Mönstrad överdel", "D3", 1236483, 2, 21)
  ];
  static List<Product> get([int count]) {
    return _products;
  }
}

// ui test, 'modePage', potentially use some dependency inject to keep pages, and mock it
class Pages {
  static List<Page> _pages = [
    Page("Plock", PlockPage()),
    Page("Inventering", Text("Inventering")),
    Page("Tidsstatistik", Text("Tidsstatistik")),
    Page("Mätning", Text("Mätning")),
    Page("Mock1", Text("Mock1")),
    Page("Mock2", Text("Mock2"))
  ];
  static List<Page> get() {
    return _pages;
  }
}

class Page {
  String name;
  Widget widget;
  Page(String name, Widget widget) {
    this.name = name;
    this.widget = widget;
  }
}
