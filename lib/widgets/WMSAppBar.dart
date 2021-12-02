import 'package:flutter/material.dart';

// also require 'extendBodyBehindAppBar: true' to be set in parent Scaffold

// the 'WMS******' needs too be widgets
class WMSAppBar {
  final String name;
  final Color textColor;
  final Color backgroundColor;
  final Color backButtonColor;
  WMSAppBar(
      this.name, this.textColor, this.backgroundColor, this.backButtonColor);

  AppBar get() => AppBar(
        title: Text(this.name, style: TextStyle(color: textColor)),
        backgroundColor: Color.fromARGB(0, 120, 120, 120),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: backButtonColor),
      );
}



// trying to create a custom cwidget to substituted app bar
/*
class WMSAppBar extends AppBar {
  final String name;
  final Color textColor;
  WMSAppBar(this.name, this.textColor);
  

  Widget build(BuildContext context) {
    return AppBar(
        title: Text(this.name, style: TextStyle(color: textColor)),
        backgroundColor: Color.fromARGB(0, 120, 120, 120),
        elevation: 0,
        centerTitle: true);
  }
}
*/