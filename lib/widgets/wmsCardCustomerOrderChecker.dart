import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';

class WMSCardCustomerOrderChecker extends StatefulWidget {
  final CustomerOrder customerOrder;
  WMSCardCustomerOrderChecker(this.customerOrder);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WMSCardCustomerOrderChecker> {
  @override
  Widget build(BuildContext context) {
    var customerOrder = this.widget.customerOrder;
    var workStore = WorkStore.instance;
    return WMSAsyncWidget<List<dynamic>>(
        Future.wait([
          customerOrder.getCustomerName(),
          customerOrder.getProducts(),
          customerOrder.getIncrementId()
        ]),
        (f) => StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
              return Card(
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
              ));
            }));
  }

  Widget customerNameWidget(String name) => Text(name);
  Widget customerOrderProductsWidget(List<int> ps) =>
      Text(ps.length.toString() + "st");

  Widget customerOrderIncrementId(String fid) => Text(fid);
}
