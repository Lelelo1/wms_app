import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/pages/collect/collectPage.dart';
import 'package:wms_app/stores/workStore.dart';
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
  List<String> testOrders = [
    "Håkan Johannson",
    "Lis-Karin Blomqvist",
    "Linn Bladh",
    "Emma Hanssom",
    "Marcus Olsson",
  ];

  WorkStore workStore = WorkStore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(
                "Välj beställningar", Colors.black, Colors.white, Colors.black)
            .get(),
        body: Column(children: [
          Expanded(
              child: asyncCustomerOrdersList(
                  CustomerOrderProduct.fetchCustomerOrders())),
          confirmCustomerOrdersButton(context)
        ]));
  }

  WMSAsyncWidget asyncCustomerOrdersList(
          Future<List<CustomerOrderProduct>> futureCustomerOrder) =>
      WMSAsyncWidget<List<CustomerOrderProduct>>(
          futureCustomerOrder,
          (customerOrders) => ListView(children: [
                ...customerOrders.map((c) => WMSCardChecker.create(
                    WMSCardCheckerProps(
                        c.name.toString(),
                        c.displayId.toString(),
                        c.qtyOrdered.toString() + "st",
                        false,
                        (bool b) {})))
              ]));

  Widget confirmCustomerOrdersButton(BuildContext context) => ElevatedButton(
      child: Text("Bekräfta"),
      onPressed: () async {
        var printed = await WorkStore.instance.printPage(context);
        // if(printed)
        Navigator.push(context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => CollectPage()));
      });
}




//WMSAsyncWidget<String>(
 //           customerOrder.getCustomerName(), (name) => Text(name))

//WMSAsyncWidget<List<int>>(customerOrder.getProducts(),
            //  (ps) => Text(ps.length.toString() + "st"))