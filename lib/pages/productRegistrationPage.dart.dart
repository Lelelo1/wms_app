import 'package:flutter/material.dart';
import 'package:wms_app/pages/AbstractPage.dart';

class ProductRegistrationPage extends StatefulWidget implements AbstractPage {
  @override
  State<StatefulWidget> createState() => _State();

  @override
  final String name;

  ProductRegistrationPage(this.name);
}

class _State extends State<ProductRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: Text(this.widget.name)));
  }
}
