import 'package:wms_app/models/job.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';

class IdentifyJob /* implements Job*/ {
  static Future<Product> scanned(String ean) async {
    // check ean exist in warehouse system
    var workStore = AppStore.injector.get<WorkStore>();
    return await workStore.warehouseSystem.getProduct(ean);
  }
}
