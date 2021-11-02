import 'package:flutter/material.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
// also require 'extendBodyBehindAppBar: true' to be set in parent Scaffold

class WMSScaffold {
  final String name;
  final Color textColor;
  WMSScaffold(this.name, this.textColor);

  Scaffold get(Widget content) => Scaffold(
      appBar: WMSAppBar(this.name, this.textColor).get(),
      body: content,
      extendBodyBehindAppBar: true);
}
