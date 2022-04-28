import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/widgets/WMSPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WMSAppBar(
                "Välj beställningar", Colors.black, Colors.white, Colors.black)
            .get(),
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Flexible(
                  flex: 5,
                  child: asyncCustomerOrdersList(futureCustomerOrdersList())),
              Flexible(
                  flex: 2,
                  child:
                      ElevatedButton(child: Text("haahaha"), onPressed: () {}))
            ])));
  }

  Future<List<CustomerOrder>> futureCustomerOrdersList() async {
    var query = WorkStore.instance.queries.customerOrders.getCustomerOrders();
    var ids = await WSInteract.remoteSql<int>(query);
    return ids.map((e) => CustomerOrder(e)).toList();
  }

  WMSAsyncWidget asyncCustomerOrdersList(
          Future<List<CustomerOrder>> futureCustomerOrder) =>
      WMSAsyncWidget<List<CustomerOrder>>(
          futureCustomerOrder,
          (customerOrders) => Column(
              children:
                  customerOrders.map((e) => customerOrderWidget(e)).toList()));

  Widget customerOrderWidget(CustomerOrder customerOrder) => Card(
          child: Row(children: [
        Column(children: [
          WMSAsyncWidget<String>(
              customerOrder.getCustomerName(), (name) => Text(name))
        ]),
        Text(customerOrder.id.toString())
      ]));
}
