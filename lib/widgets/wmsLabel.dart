import 'package:flutter/material.dart';

class WMSLabel extends StatelessWidget {
  final String text;
  final IconData iconData;

  //final EdgeInsets edgeInsets;
  // final double spacing = 8;
  WMSLabel(this.text, this.iconData /*, this.edgeInsets*/);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(children: [
      Spacer(flex: 6),
      Icon(this.iconData),
      Spacer(flex: 1),
      Text(this.text, style: TextStyle()),
      Spacer(flex: 6)
    ]));
  }
}
// to use spacer to set small space without having to make rest or children expanded....
