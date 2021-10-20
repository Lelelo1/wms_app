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
  static CameraImage streamImage;
  //static XFile photoFile;
  static void updateCurrentImage(CameraImage img) {
    streamImage = img;

    //print("imageStream");
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
      //_cameraController.setFlashMode(FlashMode.always); // null crash...

      // use stream image, or when commented out take ordinary photo to file and use
      _cameraController.startImageStream(updateCurrentImage);
    }
    // need a new controller each time rerendered

    return _cameraController;
  }

  static AudioCache _audioCache;
  static bool _canVibrate;
  static Future<void> scanningSuccessfull() async {
    if (_audioCache == null) {
      _audioCache = AudioCache();
      // low latency mode allows fast and immedite beeps: https://stackoverflow.com/questions/59610504/flutter-audioplayers-delay
      _audioCache.fixedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
      _audioCache.fixedPlayer.setVolume(0);
    }

    if (_canVibrate == null) {
      _canVibrate = await Vibrate.canVibrate;
    }

    /*
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    } // vibration is made first despite called, but feels ok
    */

    _audioCache
        .play("sounds/scanner_beep.mp3"); // (should be able to use waw also)
  }

  static Future<XFile> takePhoto() async =>
      (await getCameraControllerInstance()).takePicture();
}

class CameraView extends StatefulWidget {
  Size size;
  CameraView([this.size]);
  @override
  _State createState() => _State();
}

// WidgetsBindingObserver
// needed to to detect app lifecycle events: https://medium.com/pharos-production/flutter-app-lifecycle-4b0ab4a4211a
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
    if (controller == null) {
      return Container(
          child: Center(
              child: Text("something went wrong with the CameraController")));
    }

    var size = MediaQuery.of(context).size;
    var aspectRatio = size.width / size.height;
    var width = size.width; //this.widget.size.width;

    return Flexible(
        child: Container(
      width: width,
      height: size.height,
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
    ));

    //return camera(controller);
  }

  /*
  Widget camera(CameraController controller) {
    return Expanded(
      child: Center(
        child: AspectRatio(
          aspectRatio: 1 / controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
  */
  @override
  Widget build(BuildContext context) => futureBuilder();
}
