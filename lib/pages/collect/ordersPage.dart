import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/collect/collectPage.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/widgets.dart';
import 'package:wms_app/widgets/wmsCustomerOrderView.dart';
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
        body: EventSubscriber(
            event: CollectStore.instance.selectCustomerOrderEvent,
            handler: (_, __) =>
                asyncCustomerOrdersList(CustomerOrder.many(), context)));
  }

  WMSAsyncWidget asyncCustomerOrdersList(
          Future<List<CustomerOrder>> futureCustomerOrder,
          BuildContext context) =>
      WMSAsyncWidget<List<CustomerOrder>>(
          futureCustomerOrder,
          (co) => ListView(children: [
                ...co.map((c) => WMSCardChecker.create(c, updateState)),
                confirmCustomerOrdersButton(context),
                Widgets.seperator(Color.fromARGB(102, 138, 66, 245)),
                Card(
                    child: Column(children: [...productViews(co)]),
                    color: Colors.brown)
              ]));

  List<Widget> productViews(List<CustomerOrder> co) {
    return co
        .where((co) => co.isChosen)
        .map((c) => Column(children: [
              asyncCustomerOrderView(
                  c.name,
                  Future.wait(
                      [...c.productId.map((id) => Product.fetchFromId(id))])),
              Widgets.seperator(Colors.black)
            ]))
        .toList();
  }

  WMSAsyncWidget asyncCustomerOrderView(
          String customerName, Future<List<Product>> futureProducts) =>
      WMSAsyncWidget<List<Product>>(futureProducts,
          (products) => WMSCustomerOrderView(customerName, products));

  void updateState() {
    //setState(() {});
  }

  Widget confirmCustomerOrdersButton(BuildContext context) => Padding(
      child: ElevatedButton(
          child: Text("Skriv ut följesedlar"), // singlular plural
          onPressed: () async {
            //var printed = await WorkStore.instance.printPage(context);

            await CollectStore.instance.collect();

            print("navgigating p: " +
                WorkStore.instance.currentProduct.toString());
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (_, __, ___) => CollectPage()));
          }),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15));
}




//WMSAsyncWidget<String>(
 //           customerOrder.getCustomerName(), (name) => Text(name))

//WMSAsyncWidget<List<int>>(customerOrder.getProducts(),
            //  (ps) => Text(ps.length.toString() + "st"))