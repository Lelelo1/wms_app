// make a extension method on all widgets and check of isEmpty
import 'package:flutter/material.dart';
import 'package:wms_app/widgets/wmsPage.dart';

class WMSEmptyWidget extends StatefulWidget implements WMSPage {
  @override
  State<StatefulWidget> createState() => _State();

  @override
  final String name = "";

  const WMSEmptyWidget();
}

class _State extends State<WMSEmptyWidget> {
  @override
  Widget build(BuildContext context) => Container();
}
