import 'package:flutter/material.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/models/configuration.dart';
import 'package:wms_app/pages/featuresPage.dart';
import 'package:wms_app/pages/returnPage.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';

class VersionStore {
  static late VersionStore instance = VersionStore();

  Configuration configuration = Configuration.none();
  /*
  Configuration get configuration {
    return _configuration;
  }
  */
  void setConfiguration(Configuration configuration) {
    configuration = configuration;

    print("wms_app: configuration: " + configuration.value);
  }

  Widget getStartPage() {
    if (configuration.value == "dev") {
      return _dev();
    }
    return _release();
  }

  Widget _dev() {
    return FeaturesPage("All Features dev");
  }

  Widget _release() {
    return ReturnPage("Se hyllplats");
  }

  String getDatabase() {
    var databases = WMSKatsumiDatabaseSettings.databases;

    var hasDatabase = databases.containsKey(configuration.value);

    if (!hasDatabase) {
      throw Exception(
          "wms_app: katsumi warhouse database settings did not have database set to the following wms_app confuguration: " +
              configuration.value);
    }

    return databases[configuration.value] ?? "";
  }
}
