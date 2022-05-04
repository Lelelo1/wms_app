import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';

class WMSCardChecker extends StatefulWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final bool Function() isChecked;
  final void Function(bool checked) onChecked;
  WMSCardChecker(
      this.title, this.subtitle, this.trailing, this.isChecked, this.onChecked);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WMSCardChecker> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Card(
          child: ListTile(
        leading: Checkbox(
            value: this.widget.isChecked(),
            onChanged: (bool? b) {
              var checked = Default.nullSafe<bool>(b);
              this.widget.onChecked(checked);
              setState(() {});
            }),
        title: Text(this.widget.title),
        subtitle: Text(this.widget.subtitle),
        trailing: Text(this.widget.trailing),
      ));
    });
  }

  Widget customerNameWidget(String name) => Text(name);
  Widget customerOrderProductsWidget(String ps) => Text(ps);

  Widget customerOrderIncrementId(String fid) => Text(fid);
}
