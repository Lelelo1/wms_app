import 'package:flutter/material.dart';
//import 'package:wms_app/models/job.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';

typedef Job = Widget Function(WMSAsyncWidget asyncWidget);

/*
class Job {
  String name;
  Future<Product> Function(String sku) identify;

  // list other methods depending on job, counting, collect etc
  Job(this.name, this.identify);
}
*/
