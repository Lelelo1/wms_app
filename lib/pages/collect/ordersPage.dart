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
        body: Column(children: [
          Expanded(child: asyncCustomerOrdersList(futureCustomerOrdersList())),
          confirmCustomerOrdersButton()
        ]));
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
          (customerOrders) => ListView(children: [
                ...customerOrders
                    .map((e) => asyncCustomerOrderWidget(e))
                    .toList()
              ]));

  Widget asyncCustomerOrderWidget(CustomerOrder customerOrder) {
    return WMSAsyncWidget<List<dynamic>>(
        Future.wait([
          customerOrder.getCustomerName(),
          customerOrder.getProducts(),
          customerOrder.getIncrementId()
        ]),
        (f) => Card(
                child: ListTile(
              leading: Checkbox(value: false, onChanged: selection),
              title: customerNameWidget(f[0]),
              subtitle: customerOrderProductsWidget(f[1]),
              trailing: customerOrderIncrementId(f[2]),
            )));
  }

  void selection(bool? b) {}

  Widget customerNameWidget(String name) => Text(name);
  Widget customerOrderProductsWidget(List<int> ps) =>
      Text(ps.length.toString() + "st");

  Widget customerOrderIncrementId(String fid) => Text(fid);

  Widget confirmCustomerOrdersButton() =>
      ElevatedButton(child: Text("Bekräfta"), onPressed: () {});
}




//WMSAsyncWidget<String>(
 //           customerOrder.getCustomerName(), (name) => Text(name))

//WMSAsyncWidget<List<int>>(customerOrder.getProducts(),
            //  (ps) => Text(ps.length.toString() + "st"))