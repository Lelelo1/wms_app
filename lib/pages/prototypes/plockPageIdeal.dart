import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PlockPageIdeal extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<PlockPageIdeal> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    var cameras = await availableCameras();
    if (cameras?.length == 0) {
      print("there where no cameras on this device");
      cameraControllerCompleter.complete(null);
      return null;
    }

    var controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();
    cameraControllerCompleter.complete(controller);
  }

  Completer<CameraController> cameraControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraController>(
        future: cameraControllerCompleter.future,
        builder:
            (BuildContext context, AsyncSnapshot<CameraController> snapshot) {
          var controller = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            // happens first run
            return Container();
          }

          if (controller == null) {
            return Text("Ops, something went wrong with cameras :(");
          }
          return CameraPreview(controller);
        });
  }
}
