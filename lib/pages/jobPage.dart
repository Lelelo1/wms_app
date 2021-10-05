import 'package:flutter/widgets.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/AbstractPage.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/views/searchView.dart';

class JobPage extends StatefulWidget implements AbstractPage {
  final Job job;

  JobPage(this.job);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JobPage> {
  String identifyEAN;

  @override
  Widget build(BuildContext context) => Utils.hasValue(this.identifyEAN)
      ? SearchView(closeSearchView, preformJob)
      : ScanPage(this.widget.job.name, this.successfullScan);

  void successfullScan(String ean) {
    setState(() {
      identifyEAN = ean;
    });
  }

  void closeSearchView() {
    setState(() {
      identifyEAN = null;
    });
  }

  void preformJob(Product product) async {
    var productName = await product.getName();
    var productId = product.id;
    print("preform job " +
        this.widget.job.name +
        " with product" +
        productName +
        " id: " +
        productId.toString());
  }
}
