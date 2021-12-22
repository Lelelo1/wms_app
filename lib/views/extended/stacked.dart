import 'package:flutter/material.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

// wrap a view and add scrollable bottom content to it

class WMSStacked extends StatelessWidget {
  final Widget content;
  final Widget layer;
  WMSStacked(this.content, this.layer);
  @override
  Widget build(BuildContext context) => renderContent();

  Widget renderContent() => layer is WMSEmptyWidget ? content : renderLayer();
  Widget renderLayer() {
    return Stack(children: [this.content, this.layer]);
  }
}
