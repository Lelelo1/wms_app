import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';
import 'package:wms_app/version/versionPages.dart';

class VersionWarehouseSystem {
  static String getDatabase(String key) {
    var databases = WMSKatsumiDatabaseSettings.databases;

    if (databases.containsKey((key))) {
      return databases[key] ?? "";
    }

    // could be branch is sub branch of 'dev'
    return databases[VersionPages.dev] ?? "";
  }
}
