class Default {
  //static defaultConverterString(String? value, [String to = '']) => value ?? to;
  static String firstStringDefaultTo(List<String> values, [String to = '']) {
    if (values.isEmpty) {
      return to;
    }

    var value = values.first;
    if (value.isEmpty) {
      return to;
    }

    return value;
  }

  static double firstDoubleDefaultTo(List<double> values, [double to = 0]) {
    if (values.isEmpty) {
      return to;
    }

    return values.first;
  }

  static int firstIntDefaultTo(List<int> values, [int to = 0]) {
    if (values.isEmpty) {
      return to;
    }

    return values.first;
  }

  static T nullSafe<T>(dynamic dyn) {
    /*
    if (dyn is String?) {
      return _defaultString(dyn) as T;
    }

    if (dyn is int?) {
      return _defaultInt(dyn) as T;
    }

    if (dyn is bool?) {
      return _defaultBool(dyn) as T;
    }
  */
    return dyn as T;
  }

  static String _defaultString(dynamic dyn) {
    return dyn == null ? "" : dyn as String;
  }

  static int _defaultInt(dynamic dyn) {
    return dyn == null ? 0 : dyn as int;
  }

  static bool _defaultBool(dynamic dyn) {
    return dyn == null ? false : dyn;
  }

  static int? firstNullableIntDefaultTo(List<int?> values, [int? to]) {
    if (values.isEmpty) {
      return to;
    }

    return values.first;
  }

  static int? convertToNullableInt(String? nullableString) {
    if (nullableString == null || nullableString.isEmpty) {
      return null;
    }
    var string = nullableString;
    print("string: " + string);
    return 0; //int.tryParse(string);
  }

  static String? convertToNullableString(int? nullableInt) {
    if (nullableInt == null) {
      return null;
    }

    return nullableInt.toString();
  }

  static int? toNullableInt(bool? value) {
    if (value == null) {
      return null;
    }

    if (value == true) {
      return 1;
    }

    return 0;
  }

  static _Bool boolType = _Bool();
  static _Int intType = _Int();
}

class _Bool {
  bool fromNullable(bool? value) {
    return value ?? false;
  }

  bool fromInt(int value) {
    if (value == 0) {
      return false;
    }

    if (value == 1) {
      return true;
    }

    throw new Exception("wms exeption _Bool.fromInt");
  }
}

class _Int {
  int fromNullable(int? value) {
    return value ?? 0;
  }
}
