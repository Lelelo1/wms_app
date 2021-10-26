import 'package:flutter/material.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/pages/jobPage.dart';

import 'abstractPage.dart';

class ProductPage extends StatefulWidget implements AbstractPage {
  final String name;
  final PageController pageController = PageController();

  ProductPage(this.name, this.job) {}

  @override
  State<StatefulWidget> createState() => _State();

  @override
  // TODO: implement job
  Job job;
}

class _State extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: PageView(children: [
      JobPage(Job("jobtask", Jobs.identify)),
      Center(child: Text("produkt information"))
    ], scrollDirection: Axis.vertical));
  }
}
