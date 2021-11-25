import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/utils.dart';

// wrap a view and add scrollable bottom content to it

class WMSScrollable extends StatelessWidget {
  final PageController pageController = PageController();

  final Widget content;
  // final Product product;
  final Widget scrollRoute;

  WMSScrollable(this.content, this.scrollRoute);

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: this.pageController,
        children: renderContent(),
        scrollDirection: Axis.vertical,
        physics: this.scrollRoute is WMSEmptyWidget
            ? null
            : NeverScrollableScrollPhysics());
  }

  List<Widget> renderContent() =>
      scrollRoute is WMSEmptyWidget ? [content, scrollRoute] : [content];
}
