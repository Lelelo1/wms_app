import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PlockPageIdeal extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<PlockPageIdeal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return cameraScanning();
  }

  cameraScanning() {
    return Container();
  }
}
