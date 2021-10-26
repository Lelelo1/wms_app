import 'package:wms_app/jobs/identify.dart';

abstract class AbstractPage {
  // name should maybe be called 'featureName' and be more specific
  //String
  //get name; // for some eason 'final' in the widget page and 'get' matches

  Job get job;
}
