import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wms_app/pages/searchPage.dart';

class SearchRoute extends StatelessWidget {
  final SearchPage searchPage;

  SearchRoute(this.searchPage);

  @override
  Widget build(BuildContext context) {
    return _BlurView(Opacity(child: searchPage, opacity: 0.94));
  }
}

// creata fade component
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
