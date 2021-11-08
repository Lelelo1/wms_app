import 'package:flutter/material.dart';

class WMSLabel extends StatelessWidget {
  final String text;
  final IconData iconData;

  WMSLabel(this.text, this.iconData);

  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(this.iconData), Text(this.text)]);
  }
}
