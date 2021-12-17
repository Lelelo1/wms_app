import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:wms_app/widgets/wmsLoadingPage.dart';
import 'package:wms_app/utils.dart';

// page which has future builder contraint should probably be called content
// the loagingage loadingcontent
// (futurebuilder pattern is need everywhere)

// this shoudld pe put into the dependency injector
class CameraViewController {
  static late CameraViewController instance = CameraViewController();

  // rename to 'scanning controll'?
  static CameraImage? streamImage;
  //static XFile photoFile;
  static void updateCurrentImage(CameraImage img) {
    streamImage = img;
    //print("imageStream");
  }

  static void pauseImageStream() async {
    (await _cameraController).stopImageStream();
  }

  static void startImageStream() async {
    (await _cameraController).startImageStream(updateCurrentImage);
  }

  static late Future<CameraController> _cameraController =
      _createCameraController();

  static Future<CameraController> _createCameraController() async {
    var cameras = await availableCameras();
    if (cameras.length == 0) {
      throw new Exception("You need a device with camera use WMS App");
    }
    var cameraController = CameraController(cameras[0], ResolutionPreset.max);
    await cameraController.initialize();
    return cameraController;
  }

  static AudioCache? _audioCache;
  // static bool? _canVibrate;
  static Future<void> scanningSuccessfull() async {
    if (_audioCache == null) {
      _audioCache = AudioCache();
      // low latency mode allows fast and immedite beeps: https://stackoverflow.com/questions/59610504/flutter-audioplayers-delay
      _audioCache?.fixedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
      _audioCache?.fixedPlayer?.setVolume(0);
    }

    /*
    // required compatible package, also feature might noe bed needed
    if (_canVibrate == null) {
      _canVibrate = await Vibrate.canVibrate;
    }
    */

    _audioCache
        ?.play("sounds/scanner_beep.mp3"); // (should be able to use waw also)
  }

  static Future<XFile> takePhoto() async =>
      (await _cameraController).takePicture();
}

class CameraView extends StatefulWidget {
  Size? size;
  CameraView([this.size]);
  @override
  _State createState() => _State();
}

// WidgetsBindingObserver
// needed to to detect app lifecycle events: https://medium.com/pharos-production/flutter-app-lifecycle-4b0ab4a4211a
class _State extends State<CameraView> {
  FutureBuilder futureBuilder() => FutureBuilder<CameraController?>(
      future: CameraViewController._cameraController, // <--!!!
      builder:
          (BuildContext context, AsyncSnapshot<CameraController?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }

        return content(snapshot.data);
      });

  Widget content(CameraController? controller) {
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
