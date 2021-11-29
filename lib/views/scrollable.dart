import 'package:flutter/material.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

// wrap a view and add scrollable bottom content to it

class WMSScrollable extends StatelessWidget {
  final PageController pageController = PageController();

  final Widget content;
  final Widget scrollRoute;

  WMSScrollable(this.content, this.scrollRoute);
  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: this.pageController,
        children: renderContent(),
        scrollDirection: Axis.vertical,
        physics: this.scrollRoute is WMSEmptyWidget
            ? NeverScrollableScrollPhysics()
            : null);
  }

  List<Widget> renderContent() =>
      scrollRoute is WMSEmptyWidget ? [content] : [content, scrollRoute];
}
