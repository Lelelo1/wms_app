import 'package:flutter/material.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/stores/workStore.dart';

abstract class WMSPage extends StatefulWidget {
  final workStore = WorkStore.instance;

  String name = "WMSPage";
  Transition imageContent;
  Transition fadeContent;
  Transition scrollContent;

  WMSPage(this.name, this.imageContent, this.fadeContent, this.scrollContent);
}
