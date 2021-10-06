import 'package:flutter/material.dart';
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
  //String identifyEAN;

  @override
  Widget build(BuildContext context) =>
      ScanPage(this.widget.job.name, this.successfullScan);
  // probably need to make fade and do transperency within SearchView component to make it
  // appear/dissapear and use Stack here oustide of it

  void successfullScan(String ean) {
    print("Successfull scaaaan!: " + ean);
    Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) =>
                SearchView(ean, closeSearchView, preformJob)));
  }

  void closeSearchView() {
    /*
    setState(() {
      this.currentView = getScanPage();
    });
    */
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
