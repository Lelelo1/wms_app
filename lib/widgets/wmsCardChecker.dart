import 'package:flutter/material.dart';
import 'package:wms_app/utils/default.dart';

abstract class WMSCardCheckerProps /* extends WMSProps<WMSCardCheckerProps>*/ {
  abstract final String title;
  abstract final String subtitle;
  abstract final String trailing;
  abstract final bool isChecked;
  abstract final Future<void> Function(bool checked) onChecked;
  abstract final Future<WMSCardCheckerProps> Function() update;
  /*
  WMSCardCheckerProps(this.title, this.subtitle, this.trailing, this.isChecked,
      this.onChecked, this.update);
      */
}

class WMSCardChecker<P extends WMSCardCheckerProps> {
  final WMSCardCheckerProps props;
  WMSCardChecker(this.props);

  static StatefulBuilder create(WMSCardCheckerProps props) {
    var p = props;
    return StatefulBuilder(
        builder: (_, setState) => ListTile(
              leading: Checkbox(
                  value: p.isChecked,
                  onChanged: (bool? b) async {
                    var checked = Default.nullSafe<bool>(b);
                    await p.onChecked(checked);
                    var newProps = await p.update();
                    setState(() {
                      p = newProps;
                    });
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
