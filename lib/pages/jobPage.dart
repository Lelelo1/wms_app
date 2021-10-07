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
  Widget view;

  @override
  Widget build(BuildContext context) => getCurrentView(this.view);
  // probably need to make fade and do transperency within SearchView component to make it
  // appear/dissapear and use Stack here oustide of it

  Widget getCurrentView(Widget view) =>
      AnimatedSwitcher(child: view, duration: Duration(milliseconds: 200));

  Widget getScanPage() => ScanPage(this.widget.job.name, this.successfullScan);

  void successfullScan(String ean) {
    print("Successfull scaaaan!: " + ean);
    setState(() {
      this.view = SearchView(ean, closeSearchView, preformJob);
    });
    /*
    Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) =>
                ;
                */
  }

  void closeSearchView() {
    setState(() {
      this.view = getScanPage();
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
