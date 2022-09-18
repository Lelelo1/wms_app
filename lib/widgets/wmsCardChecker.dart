import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/utils/arg.dart';
import 'package:wms_app/utils/default.dart';

abstract class WMSCardCheckerProps /* extends WMSProps<WMSCardCheckerProps>*/ {
  abstract final String title;
  abstract final String subtitle;
  abstract final String trailing;
  abstract final bool isChecked;
  //abstract final Future<void> Function(bool checked) onChecked;
  // update single customer order
  //Future<WMSCardCheckerProps> update();
}

class WMSCardChecker<P extends WMSCardCheckerProps> {
  final WMSCardCheckerProps props;

  WMSCardChecker(this.props);

  // 'listener'
  // since card checker props is implemented on model. orderpags list can't have its
  // state updated, unless event subscriber and use of stores
  // So it might be better just use this listener (shorterm)

  static StatefulBuilder create(WMSCardCheckerProps props) {
    var p = props;
    return StatefulBuilder(
        builder: (_, setState) => ListTile(
              leading: Checkbox(
                  value: p.isChecked,
                  onChanged: (bool? b) async {
                    var picked = Default.boolType.fromNullable(b);
                    var customerOrder = props as CustomerOrder;

                    if (!customerOrder.hasStarted) {
                      await customerOrder.setQtyPickedAll(picked);
                    }

                    CollectStore.instance.selectCustomerOrderEvent.broadcast(
                        Arg(CustomerOrderSelectedEvent(customerOrder, picked)));
                  }),
              title: Text(p.title),
              subtitle: Text(p.subtitle),
              trailing: Text(p.trailing),
            ));
  }

  Widget customerNameWidget(String name) => Text(name);
  Widget customerOrderProductsWidget(String ps) => Text(ps);

  Widget customerOrderIncrementId(String fid) => Text(fid);
}
