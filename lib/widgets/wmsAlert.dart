import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wms_app/content/transitions.dart';
import 'package:wms_app/pages/scanPage.dart';
import 'package:wms_app/pages/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/services/navigationService.dart';
import 'package:wms_app/services/scanHandler.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/extended/scrollable.dart';
import 'package:wms_app/widgets/wmsPage.dart';
import 'package:wms_app/widgets/wmsAppBar.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';
import 'package:wms_app/widgets/wmsTransitions.dart';
import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../utils.dart';

class WMSAlert {
  static Alert get(String desc,  void Function() onPress) { 
       
      var context = NavigationService.navigatorKey.currentContext;
      if(context == null) {
        return null;
      }

  
       return Alert(
        context:  ?? ,
        desc:
            desc,
        buttons: [
          DialogButton(
            onPressed: onPress,
            child: Text("Ja"),
          ),
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Nej"),
          )
        ]);
  };
  }
}
