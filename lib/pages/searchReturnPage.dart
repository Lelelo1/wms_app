import 'package:flutter/material.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';

class SearchReturnPage extends StatefulWidget implements WMSPage {
  final String name = "Retur";

  /*
  final void Function() pressedClose;
  final void Function(Product) pressedSubmit;
  */
  // how to assign optiomal function default set default vale const
  //final TextEditingController _textController = TextEditingController();
  SearchReturnPage();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SearchReturnPage> {
  String text = "";
  List<Product> suggestedProducts = [];
  Product selectedProduct = Product.createEmpty;

  @override
  Widget build(BuildContext context) {
    return content(context);
  }

  Widget content(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(
                this.widget.name, Colors.black, Colors.white, Colors.black)
            .get(),
        body: SafeArea(
          child: Container(
              child: (ListView(children: [
                renderTextField(),
                renderContent(this.suggestedProducts)
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
                selectedProduct.isEmpty ? TextAlign.center : TextAlign.start,
            style: TextStyle(fontSize: selectedProduct.isEmpty ? 23 : 17)),
        textStyle:
            TextStyle(), // it can maybe look abit different, as you understand that you have focused/selected the textfield
        elevation: 16,
        color: Colors.transparent,
        borderRadius: textFieldBorderRadius(),
      );

  void setInputTextState(String text) async {
    var suggestedProducts = await Product.fetchSuggestionsFromSkuText(text);
    setState(() {
      this.text = ""; //text;
      this.suggestedProducts = suggestedProducts;
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

  Color confirmButtonBodyColor = Color.fromARGB(180, 90, 57, 173);

  Widget confirmButton(Product selectedProduct) {
    return Container(
        child: MaterialButton(
          child: Text("Returnera", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (selectedProduct.isEmpty) {
              return;
            }
            await selectedProduct.increaseQty();

            // set state might not be neede
            setState(() {
              this.text = "";
              this.selectedProduct = Product.createEmpty;
              this.suggestedProducts = [];
            });

            Navigator.pop(context);
          },
          elevation: 10,
          color: confirmButtonBodyColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: confirmButtonBodyColor)),
        ),
        width: 200);
  }

  Widget renderContent(List<Product> productSuggestions) {
    print("render " + productSuggestions.length.toString() + " products");
    if (productSuggestions.isNotEmpty) {
      return ListView(
          children:
              (productSuggestions).map((e) => renderSuggestion(e)).toList(),
          shrinkWrap: true,
          padding: EdgeInsets.zero);
    } else if (!selectedProduct.isEmpty) {
      return ProductRoute(selectedProduct, confirmButton(selectedProduct));
    }

    return WMSEmptyWidget();
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
    print("name: " + suggestion.name.toString());
    return Container(
        child: MaterialButton(
          child: Align(
              child: Text(suggestion.sku, style: TextStyle(fontSize: 17)),
              alignment: Alignment.centerLeft),
          onPressed: () {
            Navigator.push(
                this.context,
                MaterialPageRoute(
                    builder: (context) =>
                        searchReturnProductRoute(suggestion)));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.only(left: this.textLeftPadding),
        ),
        height: 50,
        color: Color.fromARGB(40, 120, 120, 120));
  }

  Widget searchReturnProductRoute(Product product) {
    return Scaffold(
        appBar: WMSAppBar("Returnera", Colors.black, Colors.white, Colors.black)
            .get(),
        body: ProductRoute(product, confirmButton(product)));
  }
}
