import 'package:flutter/material.dart';

// also require 'extendBodyBehindAppBar: true' to be set in parent Scaffold

class WMSAppBar {
  final String name;
  final Color textColor;
  WMSAppBar(this.name, this.textColor);

  AppBar get() => AppBar(
      title: Text(this.name, style: TextStyle(color: textColor)),
      backgroundColor: Color.fromARGB(0, 120, 120, 120),
      elevation: 0,
      centerTitle: true);
}
