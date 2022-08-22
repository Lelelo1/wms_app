import 'package:flutter/material.dart';

class Widgets {
  static Widget seperator(Color color) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(1.0),
        height: 20,
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
