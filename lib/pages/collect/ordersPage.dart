import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/collect/collectPage.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/wmsCustomerOrderView.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsCardChecker.dart';

class OrdersPage extends WMSPage {
  @override
  State<StatefulWidget> createState() => _State();

  @override
  final String name = "Plock";
}

class _State extends State<OrdersPage> {
  WorkStore workStore = WorkStore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(
                "Välj beställningar", Colors.black, Colors.white, Colors.black)
            .get(),
        body: Column(children: [
          Expanded(child: asyncCustomerOrdersList(CustomerOrder.many())),
        ]));
  }

  WMSAsyncWidget asyncCustomerOrdersList(
          Future<List<CustomerOrder>> futureCustomerOrder) =>
      WMSAsyncWidget<List<CustomerOrder>>(
          futureCustomerOrder,
          (co) => ListView(children: [
                ...co.map((c) => WMSCardChecker.create(c, updateState)),
                Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(102, 138, 66, 245),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 15,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          )
                        ]),
                    child: WMSEmptyWidget()),
                ...co.map((c) => asyncCustomerOrderView(
                    c.name,
                    Future.wait(
                        [...c.productId.map((id) => Product.fetchFromId(id))])))
              ]));
  WMSAsyncWidget asyncCustomerOrderView(
          String customerName, Future<List<Product>> futureProducts) =>
      WMSAsyncWidget<List<Product>>(futureProducts,
          (products) => WMSCustomerOrderView(customerName, products));

  void updateState() {
    setState(() {});
  }
/*
  Widget confirmCustomerOrdersButton(BuildContext context) => ElevatedButton(
      child: Text("Bekräfta"),
      onPressed: () async {
        //var printed = await WorkStore.instance.printPage(context);

        await CollectStore.instance.collect();

        print("navgigating p: " + WorkStore.instance.currentProduct.toString());
        Navigator.push(context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => CollectPage()));
      });

      */
}




//WMSAsyncWidget<String>(
 //           customerOrder.getCustomerName(), (name) => Text(name))

//WMSAsyncWidget<List<int>>(customerOrder.getProducts(),
            //  (ps) => Text(ps.length.toString() + "st"))