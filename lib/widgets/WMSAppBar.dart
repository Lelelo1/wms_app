import 'package:flutter/material.dart';

// also require 'extendBodyBehindAppBar: true' to be set in parent Scaffold

class WMSAppBar {
  final String name;

  WMSAppBar(this.name);

  AppBar get() => AppBar(
      title: Text(this.name),
      backgroundColor: Color.fromARGB(0, 120, 120, 120),
      elevation: 0,
      centerTitle: true);
}
