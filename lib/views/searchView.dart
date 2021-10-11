import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/pages/loadingPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsTitleArea.dart';

import '../utils.dart';

class SearchView extends StatefulWidget {
  final WorkStore workStore = AppStore.injector.get<WorkStore>();
  final String ean;
  final void Function() pressedClose;
  final void Function(Product) pressedSubmit;

  SearchView(this.ean, this.pressedClose, this.pressedSubmit);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SearchView> {
  String inputText;
  Future<List<String>> skuSuggestions;
  FutureBuilder futureBuilder() => FutureBuilder<List<String>>(
      future: this.skuSuggestions,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }

        return content(snapshot.data);
      });

  @override
  Widget build(BuildContext context) {
    this.skuSuggestions =
        this.widget.workStore.warehouseSystem.getSKUSuggestions(this.inputText);
    return futureBuilder();
  }

  Widget content(List<String> skuSuggestions) {
    return Scaffold(
        //appBar: WMSAppBar(this.widget.name).get(),
        body: SafeArea(
            child: Padding(
                child: Container(
                    child: (Column(children: [
                      Text(this.widget.ean,
                          style: TextStyle(fontSize: 28),
                          textAlign: TextAlign.center),
                      Row(children: [
                        WMSTitleArea.closeButton(this.widget.pressedClose, 80),
                      ], mainAxisAlignment: MainAxisAlignment.center),
                      Stack(
                        children: [
                          renderTextField(),
                          renderSuggestions(skuSuggestions)
                        ],
                      ),
                    ])),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(90, 255, 255, 255))),
                padding: EdgeInsets.all(18))));
  }
// there is a flutter closebutton already

  // enter to sku to match it with the ean code that where scanned, select item in the list
  // TextFormField...?

  Color textFieldColor() => Color.fromARGB(255, 242, 233, 206);
  BorderRadius textFieldBorderRadius() => BorderRadius.circular(25.0);
  InputBorder inputBorder() => OutlineInputBorder(
      borderRadius: textFieldBorderRadius(),
      borderSide: BorderSide(color: textFieldColor(), width: 3.0));

  Widget renderTextField() => Material(
        child: TextFormField(
            onChanged: setInputTextState,
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
        borderRadius: textFieldBorderRadius(),
      );

  void setInputTextState(String text) {
    setState(() {
      this.skuSuggestions = null;
      this.inputText = text;
    });
  }

  Widget renderSuggestions(List<String> skuSuggestions) {
    if (skuSuggestions == null || skuSuggestions.length == 0) {
      return Container();
    }
    return Container(
        child: Column(children: (skuSuggestions).map((e) => Text(e)).toList()));
  }
}
