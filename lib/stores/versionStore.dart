import 'package:flutter/material.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/models/configuration.dart';
import 'package:wms_app/pages/common/featuresPage.dart';
import 'package:wms_app/pages/common/jobPage.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';

class VersionStore {
  static late VersionStore instance = VersionStore();

  Configuration _configuration = Configuration.none();
  /*
  Configuration get configuration {
    return _configuration;
  }
  */
  void setConfiguration(Configuration configuration) {
    _configuration = configuration;

    print("wms_app: configuration: " + configuration.value);
  }

  Widget getStartPage() {
    if (_configuration.value == "dev") {
      return _dev();
    }
    return _release();
  }

  Widget _dev() {
    return FeaturesPage("All Features dev");
  }

  Widget _release() {
    return JobPage.all("Se hyllplats", Transitions.imageContent,
        Transitions.empty, Transitions.empty);
  }

  String getDatabase() {
    var databases = WMSKatsumiDatabaseSettings.databases;

    var hasDatabase = databases.containsKey(_configuration.value);

    if (!hasDatabase) {
      throw Exception(
          "wms_app: katsumi warhouse database settings did not have database set to the following wms_app confuguration: " +
              _configuration.value);
    }

    return databases[_configuration.value] ?? "";
  }
}
