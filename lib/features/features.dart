// ui test for 'featurePage', potentially use some dependency inject to keep pages, and mock it
// features.. should given/registered, and not contain widget imports..
import 'package:flutter/material.dart';
import 'package:wms_app/pages/AbstractPage.dart';
import 'package:wms_app/pages/collectPage.dart';
import 'package:wms_app/pages/productRegistrationPage.dart.dart';

class Features {
  static List<AbstractPage> _features = [
    /*Feature("Plock-FramåtLista", PlockPageForwardList()),*/
    CollectPage("Plock"),
    DefaultPage("Inventering"),
    DefaultPage("Tidsstatistik"),
    DefaultPage("Mätning"),
    ProductRegistrationPage(
        "Lägg in streckoder"), // it should probably be renamed, as collecting also uses scanning. should probably be named 'register product'
    DefaultPage("Mock2")
  ];
  static List<AbstractPage> get() {
    return _features;
  }
}

/*
how to create lambdas
// https://stackoverflow.com/questions/63003864/lambda-expression-as-a-function-parameter-in-dart-language
typedef CreateFeature = Widget Function();
*/

class DefaultPage extends StatefulWidget implements AbstractPage {
  @override
  State<StatefulWidget> createState() => _State();

  @override
  final String name;

  DefaultPage(this.name);
}

class _State extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(this.widget.name)));
  }
}
