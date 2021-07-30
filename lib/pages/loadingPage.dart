// needed with 'FutureBuilder'(s).. :(
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) =>
      Center(child: CircularProgressIndicator());
}
