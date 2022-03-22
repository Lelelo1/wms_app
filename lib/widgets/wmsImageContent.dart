import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:flutter/material.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/extended/stacked.dart';

class CameraContent extends StatefulWidget {
  final Widget cameraView;
  final Function() tappedAddEan;
  CameraContent(this.cameraView, this.tappedAddEan);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CameraContent> {
  @override
  Widget build(BuildContext context) {
    return WMSStacked(
        this.widget.cameraView,
        EventSubscriber(
            event: WorkStore.instance.productEvent,
            handler: (BuildContext c, _) =>
                Transitions.imageContent(this.widget.tappedAddEan)));
  }
}
