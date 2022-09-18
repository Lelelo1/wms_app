import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:flutter/material.dart';
import 'package:wms_app/content/transitions.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/scanView.dart';

// https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2

class ScanPage extends StatefulWidget {
  //final AsyncMemoizer<CameraView> _memoizer = AsyncMemoizer();
  final Widget imageContent;
  final void Function() scan;
  ScanPage(this.imageContent, this.scan);

  @override
  _State createState() => _State();
}

class _State extends State<ScanPage> {
  //MediaQueryData mediaQueryData;
  // Future<Sequence> sequence;
  Future<CameraView>? cameraViewFuture;

/*
  @override
  void initState() {
    this.cameraViewFuture = this.widget._memoizer.runOnce(() => CameraView());
    super.initState();
  }
*/
/*
  // alls pages should have future builder, more or less
  FutureBuilder futureBuilder() => FutureBuilder<CameraView>(
      future: this.cameraViewFuture,
      builder: (BuildContext context, AsyncSnapshot<CameraView> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }
        //return page(snapshot.data);
        return page(snapshot.data ?? Container());
      });
      */
  // conditional renderering, searchView
  Widget page() {
    return Scaffold(
        //appBar: WMSAppBar(this.widget.name).get(),
        body: Column(children: [
          Expanded(flex: 7, child: CameraView(this.widget.imageContent)),
          Expanded(
              flex: 6,
              child: EventSubscriber(
                  event: WorkStore.instance.scanDataEvent,
                  handler: (_, __) {
                    var scanPage = ScanView(this.widget.scan);
                    print("rerender scan page");
                    return scanPage;
                  }))
        ] // camera view part of page and recontructed on 'scannedProducts' state change
            ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset:
            false); // https://stackoverflow.com/questions/49840074/keyboard-pushes-the-content-up-resizes-the-screen
  }
  // animate scanview height changes..?

  @override
  Widget build(BuildContext context) {
    return page();
  }
}
