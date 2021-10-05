import 'package:wms_app/models/job.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';

class Jobs /* implements Job*/ {
  static Future<Product> identify(String ean) async {
    // check ean exist in warehouse system
    var workStore = AppStore.injector.get<WorkStore>();
    return await workStore.warehouseSystem.getProduct(ean);
  }
}

class Job {
  String name;
  Future<Product> Function(String sku) identify;

  // list other methods depending on job, counting, collect etc
  Job(this.name, this.identify);
}
