import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsProps.dart';

class WMSCardCheckerProps extends WMSProps<WMSCardCheckerProps> {
  final String title;
  final String subtitle;
  final String trailing;
  final bool isChecked;
  final bool onChecked;

  WMSCardCheckerProps(this.title, this.subtitle, this.trailing, this.isChecked,
      this.onChecked, this.create);

  @override
  WMSCardCheckerProps Function() create;
}

class WMSCardChecker<P extends WMSCardCheckerProps> extends StatefulWidget {
  final WMSCardCheckerProps props;
  WMSCardChecker(this.props);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WMSCardChecker> {
  @override
  Widget build(BuildContext context) {
    return WMSAsyncWidget<bool>(this.widget.props.isChecked(),
        (bool isChecked) {
      return ListTile(
        leading: Checkbox(
            value: isChecked,
            onChanged: (bool? b) async {
              var checked = Default.nullSafe<bool>(b);
              await this.widget.props.onChecked(checked);
              setState(() {});
            }),
        title: Text(this.widget.props.title),
        subtitle: Text(this.widget.props.subtitle),
        trailing: Text(this.widget.props.trailing),
      );
    });
  }

  Widget customerNameWidget(String name) => Text(name);
  Widget customerOrderProductsWidget(String ps) => Text(ps);

  Widget customerOrderIncrementId(String fid) => Text(fid);
}
