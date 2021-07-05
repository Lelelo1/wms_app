import 'package:flutter/material.dart';
import 'package:wms_app/pages/featuresPage.dart';
import 'package:screen/screen.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:wms_app/stores/appStore.dart';

void main() {
  runApp(MyApp());
  Screen.keepOn(true);

  AppStore.injector = Module().initialise(Injector());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final String appName = "WMS App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName, // does not do anything inside the app
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home:
            // make home page eventually where the worker can go different areas, functionality described in 'Trello' eg
            //MyHomePage(title: appName), // title is wthat is displayed on app bar
            Scaffold(body: FeaturesPage("Features")));
  }
}



// use of barcode scanning, the 'qr_code_scanner: ^0.3.5' dependency: https://pub.dev/packages/qr_code_scanner/license
/*
Copyright 2018 Julius Canute

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/