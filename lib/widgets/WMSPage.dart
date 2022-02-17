import 'package:flutter/material.dart';
import 'package:wms_app/stores/versionStore.dart';
import 'package:wms_app/stores/workStore.dart';

abstract class WMSPage extends StatefulWidget {
  static final String configuration = VersionStore.getConfiguration().value;

  abstract final String name;
}
