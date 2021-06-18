import 'package:flutter/material.dart';
import 'package:wms_app/pages/modePage.dart';

import 'stores/test.dart';
import 'package:screen/screen.dart';

void main() {
  runApp(MyApp());
  Screen.keepOn(true);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  String appName = "WMS App";

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
            ModePage());
  }
}

class MyHomePage extends StatefulWidget {
  // make this a test view, to manually test things
  // stateless widgets
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // test setState, maybe not use setState at all though, mobx reactive instead
  /*
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
   // Products.get().forEach((p) => print(p.name)); // <-- test print by press
  }
  */
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ListView(
            children: List.from(Products.get().map((e) => Text(e.name)))));
  }
}
