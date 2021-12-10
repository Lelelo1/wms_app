import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/abstractPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/searchProductView.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/utils.dart';

class SearchPage extends StatefulWidget implements AbstractPage {
  final String name;
  final WorkStore workStore = WorkStore.instance;
  final String ean;
  /*
  final void Function() pressedClose;
  final void Function(Product) pressedSubmit;
  */
  // how to assign optiomal function default set default vale const
  //final TextEditingController _textController = TextEditingController();
  SearchPage(this.name, this.ean);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SearchPage> {
  List<Product> productSuggestions = [];
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
  String selectedSKU = "";

  String text = "";

  @override
  Widget build(BuildContext context) {
    print("build SearchPage: " + this.selectedSKU);
    return content(context);
  }

  Widget content(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar("Hitta produkten i systemet", Colors.black,
                Colors.white, Colors.black)
            .get(),
        body: SafeArea(
          child: Container(
              child: (Column(children: [
                renderTextField(),
                Expanded(child: view(context))
              ])),
              decoration:
                  BoxDecoration(color: Color.fromARGB(90, 255, 255, 255))),
        ),
        resizeToAvoidBottomInset: false);

    /*
  Widget eanTitle() {
    return Padding(
        child: Text(this.widget.ean,
            style: TextStyle(fontSize: 28), textAlign: TextAlign.center),
        padding: EdgeInsets.only(left: 3, top: 12, right: 3, bottom: 12));
        */
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
            onChanged: setInputTextState,
            autofocus: false,
            decoration: inputDecoration(),
            textAlign:
                selectedSKU.isNotEmpty ? TextAlign.center : TextAlign.start,
            style: TextStyle(fontSize: selectedSKU.isNotEmpty ? 23 : 17)),
        textStyle:
            TextStyle(), // it can maybe look abit different, as you understand that you have focused/selected the textfield
        elevation: 16,
        color: Colors.transparent,
        borderRadius: textFieldBorderRadius(),
      );

  void setInputTextState(String text) async {
    var suggestions = await this.widget.workStore.productSuggestions(text);
    setState(() {
      this.text = text;
      this.productSuggestions = suggestions;
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
      focusedBorder: inputBorder());

  Widget view(BuildContext context) {
    return selectedSKU.isNotEmpty
        ? confirmContent(context)
        : renderSuggestions(this.productSuggestions);
  }

  AbstractProduct _mockProduct = MockProduct(
      111111111,
      "eaneaneanean",
      ["assets/images/product_placeholder.png"],
      "1productnameproduct",
      "1skuskuskusku",
      "1Shelf-11-2");

  Widget confirmContent(BuildContext context) {
    // causes twice render when running whole below
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
    return Container(
        child: MaterialButton(
          child: Text("Lägg till", style: TextStyle(color: Colors.white)),
          onPressed: () {
            print("product with sku: " +
                selectedSKU +
                " was updated with ean: " +
                this.widget.ean);
            setState(() {
              selectedSKU = "";
              this.productSuggestions = [];
              this.text = "";
            });
          },
          elevation: 10,
          color: confirmButtonBodyColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: confirmButtonBodyColor)),
        ),
        width: 200);
  }

  Widget renderSuggestions(List<Product> productSuggestions) {
    if (productSuggestions.isEmpty) {
      return Container();
    }
    // needs 'Flexible' otherwise overflow pixels
    return ListView(
        children: (productSuggestions).map((e) => renderSuggestion(e)).toList(),
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
  Widget renderSuggestion(Product suggestion) {
    //var sku = await suggestion.getSKU();

    return Container(
        child: WMSAsyncWidget<String>(
            suggestion.getSKU(),
            (sku) => MaterialButton(
                  child: Align(
                      child: Text(sku, style: TextStyle(fontSize: 17)),
                      alignment: Alignment.centerLeft),
                  onPressed: () {
                    print("pressed " + sku);
                    Navigator.push(
                        this.context,
                        MaterialPageRoute(
                            builder: (context) =>
                                searchProductRoute(suggestion)));
                    return;
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.only(left: this.textLeftPadding),
                )),
        height: 50,
        color: Color.fromARGB(40, 120, 120, 120));
  }

  Widget searchProductRoute(Product product) {
    return Scaffold(
        appBar:
            WMSAppBar("Lägg till ean", Colors.black, Colors.white, Colors.black)
                .get(),
        body: ProductRoute(product, confirmButton()));
  }
}
