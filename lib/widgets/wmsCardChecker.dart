import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';

class WMSCardChecker extends StatefulWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final Future<bool> Function() isChecked;
  final Future Function(bool checked) onChecked;
  WMSCardChecker(
      this.title, this.subtitle, this.trailing, this.isChecked, this.onChecked);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WMSCardChecker> {
  @override
  Widget build(BuildContext context) {
    return WMSAsyncWidget<bool>(this.widget.isChecked(), (bool isChecked) {
      return Card(
          child: Checkbox(
              value: isChecked,
              onChanged: (bool? b) async {
                var checked = Default.nullSafe<bool>(b);
                await this.widget.onChecked(checked);
                setState(() {});
              }));
    });
  }

  Widget customerNameWidget(String name) => Text(name);
  Widget customerOrderProductsWidget(String ps) => Text(ps);

  Widget customerOrderIncrementId(String fid) => Text(fid);
}
