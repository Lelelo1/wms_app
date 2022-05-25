import 'package:flutter/material.dart';

class WMSWidget extends StatefulWidget {
  final State Function<P>() state;

  WMSWidget(this.state);

  @override
  State<StatefulWidget> createState() => state();
}
