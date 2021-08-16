import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:audioplayers/audioplayers.dart';

// both unfortunetly uses deprecated api underneath
// https://pub.dev/packages/flutter_beep
// https://pub.dev/packages/flutter_vibrate
// https://pub.dev/packages/assets_audio_player

class CameraView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CameraView> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  AudioCache audioCache;
  // https://pub.dev/packages/qr_code_scanner/example
  @override
  Widget build(BuildContext context) {
    if (audioCache == null) {
      audioCache = AudioCache();
      audioCache.fixedPlayer = AudioPlayer();
      audioCache.fixedPlayer.setVolume(0);
    }

    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  String ean;
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (this.ean != scanData?.code) {
        bool canVibrate = await Vibrate.canVibrate;

        audioCache.play(
            "sounds/scanner_beep.mp3"); // (should be able to use waw also)
        this.ean = scanData?.code;
        print("scanData: " + this.ean);

        if (canVibrate) {
          Vibrate.feedback(FeedbackType
              .success); // vibration is made first despite called, but feels ok
        }

        //FlutterBeep.beep(); // (bad sounds)

        // home driectory is 'assets/' for some reason despite having 'assets/sounds/' in pubspec.yaml
        // it is not the same as with the images

      }

      /*
      setState(() {
        this.widget.result = scanData;
      });
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
