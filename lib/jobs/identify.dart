import 'package:wms_app/models/job.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';

class Identify implements Job {
  @override
  String scanned(String ean) {
    // check ean exist in warehouse system
    var workStore = AppStore.injector.get<WorkStore>();
    workStore.warehouseSystem.
    return null;
  }
}
