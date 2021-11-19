import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/experimental/productView.dart';
import 'package:wms_app/pages/experimental/resultTransition.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/wmsScaffold.dart';

class SomeJob extends StatefulWidget {
  final ScanPage scanPage = ScanPage((s) {});
  ExperimentalProductView experimentalProductView;
  Widget scanView;
  final WorkStore workStore;
  SomeJob(this.experimentalProductView, this.scanView, this.workStore);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SomeJob> {
  @override
  Widget build(BuildContext context) {
    return WMSScaffold(
            "this.widget.name",
            Color.fromARGB(255, 194, 66,
                245) /*pageTitleColor(pageIndex)*/) // can't rerender app bar separetely in flutter. It requires whole scaffold (all content) to rerender, unless memoizing everything which should not be done to content that are specific to ProductPage there is no way of doing it
        .get(ResultTransition(
            this.widget.scanPage, this.widget.experimentalProductView));
  }
}
