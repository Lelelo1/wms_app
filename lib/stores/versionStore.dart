import 'package:flutter/material.dart';
import 'package:wms_app/models/configuration.dart';
import 'package:wms_app/pages/featuresPage.dart';
import 'package:wms_app/pages/returnPage.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';

class VersionStore {
  static late VersionStore instance = VersionStore();

  static Configuration getConfiguration() {
    var c = const String.fromEnvironment("CONFIGURATION");
    return Configuration(c);
  }

  Widget getStartPage() {
    if (getConfiguration().value == "dev") {
      return _dev();
    }
    return _release();
  }

  Widget _dev() {
    return FeaturesPage("All Features dev");
  }

  Widget _release() {
    return ReturnPage();
  }

  String getDatabase() {
    var databases = WMSKatsumiDatabaseSettings.databases;

    var hasDatabase = databases.containsKey(getConfiguration().value);

    if (!hasDatabase) {
      throw Exception(
          "wms_app: katsumi warhouse database settings did not have database set to the following wms_app confuguration: " +
              getConfiguration().value);
    }

    return databases[getConfiguration().value] ?? "";
  }
}
