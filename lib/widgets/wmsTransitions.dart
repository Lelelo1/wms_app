import 'package:wms_app/mixins/transitions.dart';

abstract class WMSTransitions {
  abstract final Transition Function() imageContent;
  abstract final Transition Function() fadeContent;
  abstract final Transition Function() scrollContent;
}
