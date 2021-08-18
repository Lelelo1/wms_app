import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// both unfortunetly uses deprecated api underneath
// https://pub.dev/packages/flutter_beep
// https://pub.dev/packages/flutter_vibrate
// https://pub.dev/packages/assets_audio_player

class CameraView extends StatefulWidget {
  final Size size;
  CameraView([this.size]);

  @override
  State<StatefulWidget> createState() => _State(this.size);
}

class _State extends State<CameraView> {
  Size size;
  _State([this.size]);

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  AudioCache audioCache;

  void setSizes(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var cameraDefaultProportionSize = 0.5;
    print("screenSizeWidth: " + screenSize.width.toString());
    this.size =
        Size(screenSize.width, screenSize.height * cameraDefaultProportionSize);
  }

  // https://pub.dev/packages/qr_code_scanner/example
  @override
  Widget build(BuildContext context) {
    if (audioCache == null) {
      audioCache = AudioCache();
      audioCache.fixedPlayer = AudioPlayer();
      audioCache.fixedPlayer.setVolume(0);
    }

    if (size == null) {
      // use default camera view size
      setSizes(context);
    }

    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    //var scanSize = (MediaQuery.of(context).size.height * 0.10);
    var scanSize = this.size.height * 0.5;
    var scanArea = scanSize;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    return Container(
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
        ),
        width: this.size.width,
        height: this.size.height);
  }

  String ean;
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      controller = controller;
    });
    controller.scannedDataStream.listen((Barcode data) async {
      bool nullNotChanged = this.ean == null && data?.code == null;
      bool valueNotChanged = this.ean == data?.code;
      print("scanData: " + data?.code);
      //controller.flipCamera();

      /*
      if (nullNotChanged || valueNotChanged) {
        if (!valueNotChanged) {
          this.ean = data?.code;
        }
        return;
      }

      this.ean = data?.code;

      bool canVibrate = await Vibrate.canVibrate;
      audioCache
          .play("sounds/scanner_beep.mp3"); // (should be able to use waw also)
      print("newScanData: " + this.ean);
      if (canVibrate) {
        Vibrate.feedback(FeedbackType
            .success); // vibration is made first despite called, but feels ok
      }
      /*
      setState(() {
        this.widget.result = scanData;
      });
      */
      */
    });
  }

  // to get hot reload to work

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
