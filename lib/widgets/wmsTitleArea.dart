import 'package:flutter/material.dart';

class WMSTitleArea {
  final String title;
  final double height;
  final void Function() pressedClose;
  WMSTitleArea(this.title, this.height, this.pressedClose);

  //Widget get() => Stack(children: [closeButton(), _title()]);

  Widget _title() {
    return Container(
        child: Row(
            children: [Text(this.title, style: TextStyle(fontSize: 28))],
            mainAxisAlignment: MainAxisAlignment.center),
        height: this.height);
  }

  static Widget closeButton(void Function() pressedClose, double height) {
    return Container(
        child: Row(children: [
          MaterialButton(
              onPressed: pressedClose, child: Icon(Icons.close), minWidth: 40)
        ], mainAxisAlignment: MainAxisAlignment.start),
        height: height);
  }
}
