import 'package:flutter/material.dart';

class WMSLabel extends StatelessWidget {
  final String text;
  final IconData iconData;

  final double paddingVertical = 20;
  final double paddingSide = 10;
  final double spacing = 8;
  WMSLabel(this.text, this.iconData);

  @override
  Widget build(BuildContext context) {
    return Padding(
        child: Row(children: [
          Icon(this.iconData),
          Container(width: spacing),
          Text(this.text),
        ], mainAxisAlignment: MainAxisAlignment.center),
        padding: EdgeInsets.only(
            left: paddingSide,
            top: paddingVertical,
            right: paddingSide,
            bottom: paddingVertical));
  }
}
