import 'package:flutter/material.dart';
import 'package:wms_app/widgets/WMSPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';

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
                  child: Column(children: [
                    ...testOrders
                        .map((e) => Container(
                            child: Text(e, textAlign: TextAlign.center),
                            alignment: Alignment.center))
                        .toList()
                  ])),
              Flexible(
                  flex: 2,
                  child:
                      ElevatedButton(child: Text("haahaha"), onPressed: () {}))
            ])));
  }
}
