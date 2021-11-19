import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/experimental/productView.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/widgets/wmsScaffold.dart';

class ResultTransition extends StatefulWidget {
  final String name = "generic work";
  final PageController pageController = PageController();
  final ScanPage scanPage;
  final ExperimentalProductView productView;

  ResultTransition(this.scanPage, this.productView);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ResultTransition> {
  Product product = Product.empty();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: this.widget.pageController,
      children: [
        this.widget.scanPage,
        this.
      ],
      scrollDirection: Axis.vertical,
      physics: this.product.isEmpty() ? NeverScrollableScrollPhysics() : null,
    );
  }
}
