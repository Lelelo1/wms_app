// make a extension method on all widgets and check of isEmpty
import 'package:flutter/material.dart';
import 'package:wms_app/widgets/wmsPage.dart';

class WMSEmptyWidget extends StatefulWidget implements WMSPage {
  const WMSEmptyWidget();

  @override
  Widget build(BuildContext context) => Container();

  @override
  State<StatefulWidget> createState() => _State();

  @override
  // TODO: implement name
  String get name => "";
}

class _State extends State<WMSEmptyWidget> {
  @override
  Widget build(BuildContext context) => Container();
}
