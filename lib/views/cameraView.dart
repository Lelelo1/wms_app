import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:wms_app/pages/loadingPage.dart';

// page which has future builder contraint should probably be called content
// the loagingage loadingcontent
// (futurebuilder pattern is need everywhere)

// this shoudld pe put into the dependency injector
class CameraViewController {
  // rename to 'scanning controll'?
  static CameraImage currentImage;

  static void updateCurrentImage(CameraImage image) {
    currentImage = image;
  }

  static void pauseImageStream() {
    _cameraController.stopImageStream();
  }

  static void resumeImageStream() {
    _cameraController.startImageStream(updateCurrentImage);
  }

  static CameraController _cameraController;
  static Future<CameraController> getCameraControllerInstance() async {
    if (_cameraController == null) {
      var cameras = await availableCameras();
      if (cameras?.length == 0) {
        print("the device did not have a camera");
        return null;
      }
      _cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await _cameraController.initialize();
      _cameraController.startImageStream(updateCurrentImage);
    }

    return _cameraController;
  }

  static AudioCache _audioCache;
  static bool _canVibrate;
  static void scanningSuccessfull() async {
    if (_audioCache == null) {
      _audioCache = AudioCache();
      _audioCache.fixedPlayer = AudioPlayer();
      _audioCache.fixedPlayer.setVolume(0);
    }

    if (_canVibrate == null) {
      _canVibrate = await Vibrate.canVibrate;
    }

    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    } // vibration is made first despite called, but feels ok

    _audioCache
        .play("sounds/scanner_beep.mp3"); // (should be able to use waw also)
  }
}

class CameraView extends StatefulWidget {
  Size size;
  CameraView(this.size);
  @override
  _State createState() => _State();
}

class _State extends State<CameraView> {
  FutureBuilder futureBuilder() => FutureBuilder<CameraController>(
      future: CameraViewController.getCameraControllerInstance(), // <--!!!
      builder:
          (BuildContext context, AsyncSnapshot<CameraController> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }

        return content(snapshot.data);
      });

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
