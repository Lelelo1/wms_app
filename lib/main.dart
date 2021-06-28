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
            Scaffold(body: FeaturesPage()));
  }
}
