import 'package:flutter/material.dart';

class PlockPageIdeal extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<PlockPageIdeal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [top()]));
  }

  Widget top() {
    return Container(
        child: Center(
            child: ButtonTheme(
                child: ElevatedButton(
                    onPressed: Scan, child: Icon(Icons.qr_code_scanner)),
                height: 200,
                minWidth: 300)),
        height: 300,
        color: Colors.grey);
  }

  void Scan() {
    print("scan");
  }
}
