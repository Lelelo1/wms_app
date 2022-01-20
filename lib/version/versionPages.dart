import 'package:flutter/material.dart';
import 'package:git_info/git_info.dart';
import 'package:wms_app/mixins/transitions.dart';
import 'package:wms_app/pages/common/featuresPage.dart';
import 'package:wms_app/pages/common/jobPage.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

class VersionPages {
  static String dev = "dev"; // show all features
  static String _stage = "stage";
  static String _prod = "prod"; // selected features for production users
  static WMSAsyncWidget startPage() =>
      WMSAsyncWidget<GitInformation>(GitInfo.get(), (info) {
        if (info.branch == _prod || info.branch == _stage) {
          return production();
        }

        return development();
        // defaulting for all sub dev branches as well
      });
  static Widget production() {
    return JobPage.all("Se hyllplats", Transitions.imageContent,
        Transitions.empty, Transitions.empty);
  }

  static Widget development() {
    return FeaturesPage("All Features dev");
  }
}
