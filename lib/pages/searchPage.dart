import 'package:flutter/material.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/pages/abstractPage.dart';
import 'package:wms_app/pages/loadingPage.dart';
import 'package:wms_app/remote/mockWarehouseSystem.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/SearchProductView.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsTitleArea.dart';

import '../utils.dart';

class SearchPage extends StatefulWidget implements AbstractPage {
  final String name;
  final WorkStore workStore = AppStore.injector.get<WorkStore>();
  final String ean;
  final void Function() pressedClose;
  final void Function(Product) pressedSubmit;
  final TextEditingController _textController = TextEditingController();
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
  String selectedSKU;

  @override
  Widget build(BuildContext context) {
    return content(context);
  }

  Widget content(BuildContext context) {
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
                Expanded(child: view(context))
              ])),
              decoration:
                  BoxDecoration(color: Color.fromARGB(90, 255, 255, 255))),
        ),
        resizeToAvoidBottomInset: false);
  }
// there is a flutter closebutton already

  // enter to sku to match it with the ean code that where scanned, select item in the list
  // TextFormField...?
  double textLeftPadding = 20;
  Color textFieldColor() => Color.fromARGB(255, 242, 233, 206);
  BorderRadius textFieldBorderRadius() => BorderRadius.circular(25.0);
  InputBorder inputBorder() => OutlineInputBorder(
      borderRadius: textFieldBorderRadius(),
      borderSide: BorderSide(color: textFieldColor(), width: 3.0));
  double textFieldHeight = 40;
  Widget renderTextField() => Material(
        child: TextFormField(
            controller: this.widget._textController,
            onChanged: setInputTextState,
            autofocus: false,
            decoration: inputDecoration(),
            textAlign: Utils.hasValue(this.selectedSKU)
                ? TextAlign.center
                : TextAlign.start,
            style: TextStyle(
                fontSize: Utils.hasValue((this.selectedSKU)) ? 23 : 17)),
        textStyle:
            TextStyle(), // it can maybe look abit different, as you understand that you have focused/selected the textfield
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

/* floatingLabelBehavior: FloatingLabelBehavior
          .always, // show hintext when having textfield selected, (and when after having cleared text)*/

  InputDecoration inputDecoration() => InputDecoration(
      hintText: 'Ange Artikelnummer',
      fillColor: textFieldColor(),
      filled: true,
      contentPadding:
          EdgeInsets.fromLTRB(this.textLeftPadding, 10.0, 20.0, 10.0),
      enabledBorder: inputBorder(),
      focusedBorder: inputBorder(),
      suffixIcon: Utils.hasValue(this.selectedSKU)
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                this.widget._textController.clear();
                setState(() {
                  this.selectedSKU = null;
                  this.skuSuggestions = null;
                });
              })
          : IconButton(
              icon: Container(),
              onPressed: () {
                // needed otherwise hintext goes missing
              }));

  Widget view(BuildContext context) {
    return Utils.hasValue(selectedSKU)
        ? confirmContent(context)
        : renderSuggestions(this.skuSuggestions);
  }

  AbstractProduct _mockProduct = MockProduct(
      111111111,
      "eaneaneanean",
      "assets/images/product_placeholder.png",
      "1productnameproduct",
      "1skuskuskusku",
      "1Shelf-11-2");

  Widget confirmContent(BuildContext context) {
    print("show confirmContent " + this.selectedSKU);
    var size = MediaQuery.of(context).size;
    var width = size.width * 0.92;
    //var height = size.height * 0.82;
    return Column(children: [
      SearchProductView(_mockProduct, width /*, height*/),
      confirmButton()
    ]);
  }

  Color confirmButtonBodyColor = Color.fromARGB(180, 90, 57, 173);

  Widget confirmButton() {
    return Expanded(
        child: Align(
            child: Container(
                child: MaterialButton(
                  child:
                      Text("Lägg till", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    print("product with sku: " +
                        this.selectedSKU +
                        " was updated with ean: " +
                        this.widget.ean);
                  },
                  elevation: 10,
                  color: confirmButtonBodyColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: confirmButtonBodyColor)),
                ),
                width: 230,
                height: 120,
                padding: EdgeInsets.only(bottom: 60)),
            alignment: Alignment.bottomCenter));
  }

  Widget renderSuggestions(List<String> skuSuggestions) {
    if (skuSuggestions == null || skuSuggestions.length == 0) {
      return Container();
    }
    // needs 'Flexible' otherwise overflow pixels
    return ListView(
        children: (skuSuggestions).map((e) => renderSuggestion(e)).toList(),
        shrinkWrap: true,
        padding: EdgeInsets.zero);
  }

//Sku:  FS6541MUI-65I
  /*
  Card(
            child: ,
            color: Color.fromARGB(135, 255, 255, 255),
            elevation: 20)
            */
  // padding: EdgeInsets.only(left: 10, right: 10)
  Widget renderSuggestion(String sku) {
    return Container(
        child: MaterialButton(
          child: Align(
              child: Text(sku, style: TextStyle(fontSize: 17)),
              alignment: Alignment.centerLeft),
          onPressed: () {
            // following code is sensitive to do 2 renderers, it is probably solved
            print("pressed " + sku);
            this.widget._textController.text = sku;
            // https://stackoverflow.com/questions/53481261/how-to-unfocus-textfield-that-has-custom-focusnode
            //this.selectedSKU = sku;
            setState(() {
              this.selectedSKU = sku;
            });
            //FocusScope.of(context).unfocus();// two renders without calling setState can happen try to do something with focus this way...
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.only(left: this.textLeftPadding),
        ),
        height: 50,
        color: Color.fromARGB(40, 120, 120, 120));
  }
}
