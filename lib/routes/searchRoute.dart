import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wms_app/pages/searchPage.dart';

class SearchRoute extends StatelessWidget {
  final String barcode;

  SearchRoute(this.barcode);

  @override
  Widget build(BuildContext context) {
    return _BlurView(Opacity(
        child: SearchPage("search", barcode, () {}, (p) {}), opacity: 0.94));
  }
}

class _BlurView extends StatelessWidget {
  final Widget widget;

  _BlurView(this.widget);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Container(
          child: this.widget,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.10)),
        ));
  }
}
