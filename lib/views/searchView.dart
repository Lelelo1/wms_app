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
                child: (Column(children: [titleArea, textField()])),
                decoration:
                    BoxDecoration(color: Color.fromARGB(90, 255, 255, 255))),
            padding: EdgeInsets.all(20)));
  }

  // enter to sku to match it with the ean code that where scanned, select item in the list
  // TextFormField...?

  Color textFieldColor() => Color.fromARGB(255, 242, 233, 206);
  BorderRadius textFieldBorderRadius() => BorderRadius.circular(25.0);
  InputBorder inputBorder() => OutlineInputBorder(
      borderRadius: textFieldBorderRadius(),
      borderSide: BorderSide(color: textFieldColor(), width: 3.0));
  Widget textField() {
    return Material(
        child: TextFormField(
            autofocus: false,
            decoration: InputDecoration(
                hintText: 'Ange Artikelnummer',
                fillColor: textFieldColor(),
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                enabledBorder: inputBorder(),
                focusedBorder:
                    inputBorder())), // it can maybe look abit different, as you understand that you have focused/selected the textfield
        elevation: 16,
        color: Colors.transparent,
        borderRadius: textFieldBorderRadius());
  }
}
