import 'package:wms_app/mixins/transitions.dart';

abstract class WMSTransitions {
  abstract final ImageContentTransition imageContent;
  abstract final Transition fadeContent;
  abstract final Transition scrollContent;
}
