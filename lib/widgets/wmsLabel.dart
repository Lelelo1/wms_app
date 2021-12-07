import 'package:flutter/material.dart';

class WMSLabel extends StatelessWidget {
  final String text;
  final IconData iconData;

  //final EdgeInsets edgeInsets;
  // final double spacing = 8;
  WMSLabel(this.text, this.iconData /*, this.edgeInsets*/);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(this.iconData),
      // Container(width: spacing),
      Spacer(flex: 1),
      Text(this.text),
    ]);
  }
}
