import 'package:flutter/material.dart';
import 'package:wms_app/pages/collect/collectPage.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/warehouseSystem/customerOrder.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsCardChecker.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

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
          Expanded(child: asyncCustomerOrdersList(futureCustomerOrdersList())),
          confirmCustomerOrdersButton(context)
        ]));
  }

  Future<List<CustomerOrder>> futureCustomerOrdersList() async {
    var query =
        WorkStore.instance.queries.customerOrders.getPossibleCustomerOrders();
    var customerOrders = await WSInteract.remoteSql<int>(query)
        .then((ids) => ids.map((id) => CustomerOrder(id)));

    var allCustomerOrders = await Future.wait(customerOrders.map((e) async {
      var isSelected = await e.getIsBeingCollected();
      return isSelected ? null : e;
    }));

    var availableCustomerOrders = allCustomerOrders
        .where((e) => e != null)
        .cast<CustomerOrder>()
        .toList();

    return Future.sync(() => availableCustomerOrders);
  }

  WMSAsyncWidget asyncCustomerOrdersList(
          Future<List<CustomerOrder>> futureCustomerOrder) =>
      WMSAsyncWidget<List<CustomerOrder>>(
          futureCustomerOrder,
          (customerOrders) => ListView(children: [
                ...customerOrders.map((e) => WMSAsyncWidget<CustomerOrder>(
                    WSInteract.,
                    (f) => WMSCardChecker(
                        f[0],
                        e.formatCustomerOrderProductsQuantity(f[1]),
                        f[2],
                        e.getIsSelected,
                        e.setQtyPickedFromChecked)))
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