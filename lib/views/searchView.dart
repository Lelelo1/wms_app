import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/widgets/wmsTitleArea.dart';

class SearchView extends StatefulWidget {
  final String ean;
  final void Function() pressedClose;
  final void Function(Product) pressedSubmit;

  SearchView(this.ean, this.pressedClose, this.pressedSubmit);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    var titleArea =
        WMSTitleArea(this.widget.ean, 80, this.widget.pressedClose).get();

    return Scaffold(
        //appBar: WMSAppBar(this.widget.name).get(),
        body: Padding(
            child: Container(
                child: (Flexible(
                    child: Column(children: [titleArea, textField()]))),
                decoration:
                    BoxDecoration(color: Color.fromARGB(90, 255, 255, 255))),
            padding: EdgeInsets.all(20)));
  }

  // enter to sku to match it with the ean code that where scanned, select item in the list
  // TextFormField...?

  // seems like textfield can't be shadowed using container or maerial widget, and having radius corner....
  Widget textField() {
    return TextField(
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Ange artikelnummer',
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45.0),
                borderSide: BorderSide(color: Colors.black, width: 3.0))));
  }
}
