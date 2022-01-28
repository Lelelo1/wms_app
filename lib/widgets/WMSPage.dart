import 'package:flutter/material.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/stores/versionStore.dart';
import 'package:wms_app/stores/workStore.dart';

abstract class WMSPage extends StatefulWidget {
  static final workStore = WorkStore.instance;

  static final String configuration = VersionStore.getConfiguration().value;

  final String name;

  abstract final Transition Function() imageContent;
  abstract final Transition Function() fadeContent;
  abstract final Transition Function() scrollContent;

  WMSPage(this.name);
}
