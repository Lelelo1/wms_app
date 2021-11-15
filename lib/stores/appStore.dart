import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:wms_app/stores/workStore.dart';

class AppStore {
  static Injector? injector;
}

// https://pub.dev/packages/flutter_simple_dependency_injection
// using one 'box'/module for now, but different can be can made and enchanged for
// .. can create test, mock dep modules
class Module {
  Injector initialise(Injector injector) {
    injector.map((injector) => WorkStore(), isSingleton: true);
    return injector;
  }
}
