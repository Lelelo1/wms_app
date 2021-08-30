import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:wms_app/pages/loadingPage.dart';

// page which has future builder contraint should probably be called content
// the loagingage loadingcontent
// (futurebuilder pattern is need everywhere)

class CameraView extends StatefulWidget {
  Size size;
  CameraView(this.size);
  @override
  _State createState() => _State();
}

class _State extends State<CameraView> {
  @override
  void initState() {
    super.initState();
    if (this.futureController == null) {
      this.futureController = setController();
    }
  }

  Future<CameraController> setController() async {
    var cameras = await availableCameras();
    if (cameras?.length == 0) {
      print("the devices did not have a camera");
      return null;
    }

    var controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();
    return controller;
  }

  Widget content(CameraController controller) {
    var size = MediaQuery.of(context).size;
    var aspectRatio = size.width / size.height;
    var width = this.widget.size.width;
    return Container(
      width: width,
      height: width,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              width: width,
              height: width / aspectRatio,
              child: CameraPreview(controller), // this is my CameraPreview
            ),
          ),
        ),
      ),
    );
  }
  /*
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  */

  @override
  Widget build(BuildContext context) => futureBuilder();

  Future<CameraController> futureController;
  FutureBuilder futureBuilder() => FutureBuilder<CameraController>(
      future: futureController,
      builder:
          (BuildContext context, AsyncSnapshot<CameraController> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }

        return content(snapshot.data);
      });

/*
  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller),
    );
  }
  */
}
