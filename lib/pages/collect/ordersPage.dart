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
    var getName = customerOrder.getCustomerName();
    var getProducts = customerOrder.getProducts();
    var getIncrementId = customerOrder.getIncrementId();

    Future.wait([getName, getProducts, getIncrementId]);

    // use wms async widget. can't call getName and getIncrementiId both otherwsie
    return Card(
        child: ListTile(
      leading: Checkbox(value: false, onChanged: selection),
      title: customerNameWidget(getName),
      subtitle: customerOrderProductsWidget(getProducts),
      trailing: customerOrderIncrementId(getIncrementId),
    ));
  }

  void selection(bool? b) {}

  Widget customerNameWidget(Future<String> fcn) =>
      WMSAsyncWidget<String>(fcn, (n) => Text(n));
  Widget customerOrderProductsWidget(Future<List<int>> fps) =>
      WMSAsyncWidget<List<int>>(fps, (ps) => Text(ps.length.toString() + "st"));
  Widget customerOrderIncrementId(Future<String> fid) =>
      WMSAsyncWidget<String>(fid, (id) => Text(id));

  Widget confirmCustomerOrdersButton() =>
      ElevatedButton(child: Text("Bekräfta"), onPressed: () {});
}




//WMSAsyncWidget<String>(
 //           customerOrder.getCustomerName(), (name) => Text(name))

//WMSAsyncWidget<List<int>>(customerOrder.getProducts(),
            //  (ps) => Text(ps.length.toString() + "st"))