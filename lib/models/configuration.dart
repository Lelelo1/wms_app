class Configuration {
  String _value = "";

  String get value => _value;

  Configuration(String v) {
    var isValid = v == "dev" || v == "stage" || v == "prod";

    if (!isValid) {
      throw Exception(
          "wms_app: The following configuration is not valid: " + v);
    }

    _value = v;
  }

  Configuration.none();
}

// enums and strings are hard to work with in dart