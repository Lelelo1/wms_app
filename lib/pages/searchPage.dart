import 'package:flutter/material.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/pages/AbstractPage.dart';
import 'package:wms_app/pages/loadingPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsTitleArea.dart';

import '../utils.dart';

class SearchPage extends StatefulWidget implements AbstractPage {
  final String name;
  final WorkStore workStore = AppStore.injector.get<WorkStore>();
  final String ean;
  final void Function() pressedClose;
  final void Function(Product) pressedSubmit;

  final Stream<List<String>> skuSuggestionsStream =
      Stream<List<String>>.empty();

  SearchPage(this.name, this.ean, this.pressedClose, this.pressedSubmit);

  @override
  State<StatefulWidget> createState() => _State();

  @override
  // TODO: implement job
  Job get job => throw UnimplementedError();
}

class _State extends State<SearchPage> {
  List<String> skuSuggestions;
  /*
  FutureBuilder futureBuilder() => FutureBuilder<List<String>>(
      future: this.skuSuggestions,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // https://stackoverflow.com/questions/52847534/flutter-futurebuilder-returning-null-error-triggered
          return LoadingPage();
        }

        return content(snapshot.data);
      });
  */

  @override
  Widget build(BuildContext context) {
    return content();
  }

  Widget content() {
    return Scaffold(
        //appBar: WMSAppBar(this.widget.name).get(),
        body: SafeArea(
          child: Container(
              child: (Column(children: [
                Padding(
                    child: Text(this.widget.ean,
                        style: TextStyle(fontSize: 28),
                        textAlign: TextAlign.center),
                    padding: EdgeInsets.only(
                        left: 3, top: 12, right: 3, bottom: 12)),
                renderTextField(),
                Flexible(child: renderSuggestions(this.skuSuggestions))
              ])),
              decoration:
                  BoxDecoration(color: Color.fromARGB(90, 255, 255, 255))),
        ),
        resizeToAvoidBottomInset: false);
  }
// there is a flutter closebutton already

  // enter to sku to match it with the ean code that where scanned, select item in the list
  // TextFormField...?

  Color textFieldColor() => Color.fromARGB(255, 242, 233, 206);
  BorderRadius textFieldBorderRadius() => BorderRadius.circular(25.0);
  InputBorder inputBorder() => OutlineInputBorder(
      borderRadius: textFieldBorderRadius(),
      borderSide: BorderSide(color: textFieldColor(), width: 3.0));
  double textFieldHeight = 40;
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

  void setInputTextState(String text) async {
    var suggestions =
        await this.widget.workStore.warehouseSystem.getSKUSuggestions(text);
    setState(() {
      this.skuSuggestions = suggestions;
    });
  }

  Widget renderSuggestions(List<String> skuSuggestions) {
    if (skuSuggestions == null || skuSuggestions.length == 0) {
      return Container();
    }

    return ListView(
        children: (skuSuggestions).map((e) => renderSuggestion(e)).toList(),
        shrinkWrap: true);
    /*
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap:
            true, // https://stackoverflow.com/questions/50688970/cant-add-a-listview-in-flutter
        itemCount: skuSuggestions.length,
        
        itemBuilder: (BuildContext context, int index) {
          return renderSuggestion(skuSuggestions[index]);
        });
    */
    /*
    return Container(
        child: Column(
            children:
                (skuSuggestions).map((e) => renderSuggestion(e)).toList()),
        color: Color.fromARGB(255, 240, 227, 213));
        */
  }

  Widget renderSuggestion(String sku) {
    return Container(
        child: Card(
            child: Padding(
              child: Align(
                  child: Text(sku, style: TextStyle(fontSize: 17)),
                  alignment: Alignment.centerLeft),
              padding: EdgeInsets.only(left: 10, right: 10),
            ),
            color: Color.fromARGB(135, 255, 255, 255),
            elevation: 20,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        height: 50);

    /*
    return Padding(
        child: Text(sku,
            textAlign: TextAlign.left,
            style: TextStyle(
                backgroundColor: Color.fromARGB(255, 240, 240, 240),
                fontSize: 18)),
        padding: EdgeInsets.all(2));
        */
  }
}
