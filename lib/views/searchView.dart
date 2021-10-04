import 'package:flutter/material.dart';
import 'package:wms_app/widgets/wmsTitleArea.dart';

class SearchView extends StatefulWidget {
  void Function() pressedClose;
  void Function() pressedSubmit;

  SearchView(this.pressedClose, this.pressedSubmit);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    var titleArea = WMSTitleArea("", 80, this.widget.pressedClose).get();
    return Container(
        child: (Flexible(child: Column(children: [titleArea, textField()]))),
        decoration: BoxDecoration(color: Color.fromARGB(90, 255, 255, 255)));
  }

  // enter to sku to match it with the ean code that where scanned, select item in the list
  // TextFormField...?
  Widget textField() {
    return TextField(
        decoration: InputDecoration(
            border: InputBorder.none, hintText: 'Ange artikelnummer'));
  }
}
