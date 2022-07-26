import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/oldcustomerOrder.dart';
import 'package:wms_app/models/product.dart';
import 'package:event/event.dart';
import 'package:wms_app/warehouseSystem/wsMapping.dart';
import 'package:wms_app/warehouseSystem/wsSqlQuery.dart';
import 'package:pdf/widgets.dart' as pw;

class WorkStore {
  static late WorkStore instance = WorkStore._();
  WorkStore._();

  // global build context: https://stackoverflow.com/questions/66139776/get-the-global-context-in-flutter
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // can use 'EventArgs' since it required nullable object
  Event _productEvent = Event();
  Event get productEvent => _productEvent;

  Product _currentProduct = Product.empty;
  Product get currentProduct => _currentProduct;
  set currentProduct(Product product) {
    _currentProduct = product;
    productEvent.broadcast();
  }

  String currentEAN = "";

  // Be mindful when depending on multiple events in the same render hiercarchy

  Future<bool> isMatchingShelf(String shelf) async {
    var currentProduct = WorkStore.instance.currentProduct;

    if (!currentProduct.exists) {
      WorkStore.instance.currentProduct = Product.empty;
      return false;
    }

    var productShelf = currentProduct.shelf;
    return shelf == productShelf;
  }

  List<String> _scanData = [];
  void addScanData(String scanData) {
    _scanData.add(scanData);
    _scanDataEvent.broadcast();
  }

  List<String> get scanData => _scanData;

  Event _scanDataEvent = Event();
  Event get scanDataEvent => _scanDataEvent;

  Event _assignShelfEvent = Event();
  Event get assignShelfEvent => _assignShelfEvent;

  String currentShelf = "";

  WSSQLQueries queries = WSSQLQueries(Mapping());

  Future<bool> printPage(BuildContext context) {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello World'),
          ); // Center
        }));

    return Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  List<CustomerOrder> chosenCustomerOrders = [];

  void setReturn() {
    this.currentProduct = Product.empty;
    this.currentEAN = "";
    this._scanData = [];
    this.currentShelf = "";
  }

  void setCollect() async {
    if (chosenCustomerOrders.length == 0) {
      print(
          "wms warning you entered collect without having any customer orderders chosen");
    }

    this.currentProduct = await Product.fetchFromId(
        chosenCustomerOrders.first.productId.toString());

    this.currentEAN = "";
    this._scanData = [];
    this.currentShelf = "";
  }

/*
  Iterable<CustomerOrder> _selectedCustomerOrders = [];
  Iterable<CustomerOrder> get selectedCustomerOrders => _selectedCustomerOrders;
  void _selectCustomerOrder(CustomerOrder customerOrder) {
    _selectedCustomerOrders = [..._selectedCustomerOrders, customerOrder];
  }

  void _unselectCustomerOrder(CustomerOrder customerOrder) {
    _selectedCustomerOrders = _selectedCustomerOrders
        .where((element) => element.id != customerOrder.id);
  }

  void setCustomerOrderSelected(bool selected, CustomerOrder customerOrder) {
    if (isSelectedCustomerOrder(customerOrder)) {
      _selectCustomerOrder(customerOrder);
    } else {
      _unselectCustomerOrder(customerOrder);
    }
  }

  
  bool isSelectedCustomerOrder(CustomerOrder customerOrder) =>
      _selectedCustomerOrders.map((e) => e.id).contains(customerOrder.id);
      */
}
