import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/pages/collect/collectPage.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
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
              leading: Checkbox(
                  value: workStore.isSelectedCustomerOrder(customerOrder),
                  onChanged: (bool? b) {
                    var selected = Default.nullSafe<bool>(b);
                    if (selected) {
                      if (!workStore.isSelectedCustomerOrder(customerOrder)) {
                        workStore.selectCustomerOrder(customerOrder);
                      }
                    } else {
                      if (workStore.isSelectedCustomerOrder(customerOrder)) {
                        workStore.unselectCustomerOrder(customerOrder);
                      }
                    }
                    setState(() {});
                  }),
              title: customerNameWidget(f[0]),
              subtitle: customerOrderProductsWidget(f[1]),
              trailing: customerOrderIncrementId(f[2]),
            )));
  }

  Widget customerNameWidget(String name) => Text(name);
  Widget customerOrderProductsWidget(List<int> ps) =>
      Text(ps.length.toString() + "st");

  Widget customerOrderIncrementId(String fid) => Text(fid);

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