import 'package:flutter/material.dart';

class Widgets {
  static Widget seperator(Color color) {
    return Container(
        height: 8,
        decoration: BoxDecoration(color: color, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          )
        ]));
  }
}
