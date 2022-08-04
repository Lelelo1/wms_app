import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/pages/collect/collectPage.dart';
import 'package:wms_app/stores/collectStore.dart';
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
  WorkStore workStore = WorkStore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(
                "Välj beställningar", Colors.black, Colors.white, Colors.black)
            .get(),
        body: Column(children: [
          Expanded(child: asyncCustomerOrdersList(CustomerOrder.many())),
          confirmCustomerOrdersButton(context)
        ]));
  }

  WMSAsyncWidget asyncCustomerOrdersList(
          Future<List<CustomerOrder>> futureCustomerOrder) =>
      WMSAsyncWidget<List<CustomerOrder>>(
          futureCustomerOrder,
          (customerOrders) => ListView(children: [
                ...customerOrders.map((c) => WMSCardChecker.create(c))
              ]));

  Widget confirmCustomerOrdersButton(BuildContext context) => ElevatedButton(
      child: Text("Bekräfta"),
      onPressed: () async {
        //var printed = await WorkStore.instance.printPage(context);
        // if(printed)

        var collectRoute = await CollectStore.instance.collect();

        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => CollectPage(collectRoute)));
      });
}




//WMSAsyncWidget<String>(
 //           customerOrder.getCustomerName(), (name) => Text(name))

//WMSAsyncWidget<List<int>>(customerOrder.getProducts(),
            //  (ps) => Text(ps.length.toString() + "st"))