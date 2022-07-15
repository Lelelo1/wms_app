import 'package:flutter/material.dart';
import 'package:wms_app/utils/default.dart';

class WMSCardCheckerProps /* extends WMSProps<WMSCardCheckerProps>*/ {
  final String title;
  final String subtitle;
  final String trailing;
  final bool isChecked;
  final void Function(bool checked) onChecked;

  WMSCardCheckerProps(
      this.title, this.subtitle, this.trailing, this.isChecked, this.onChecked);
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
                    /*
                    var newProps = await p.update();
                    setState(() {
                      p = newProps;
                    });
                    */
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
