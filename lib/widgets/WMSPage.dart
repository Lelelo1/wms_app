import 'package:flutter/material.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/stores/versionStore.dart';
import 'package:wms_app/stores/workStore.dart';

abstract class WMSPage extends StatefulWidget {
  static final workStore = WorkStore.instance;
  static final versionStore = VersionStore.instance;

  static final String configuration = WMSPage.versionStore.configuration.value;

  final String name;

  abstract Transition Function() imageContent;
  abstract Transition Function() fadeContent;
  abstract Transition Function() scrollContent;

  WMSPage(this.name);
}
