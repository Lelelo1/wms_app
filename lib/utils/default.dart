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
      return defaultString(dyn) as T;
    }

    if (dyn is int?) {
      return defaultInt(dyn) as T;
    }
    */

    return dyn as T;
  }

  static String defaultString(dynamic dyn) {
    return dyn == null ? "" : dyn as String;
  }

  static int defaultInt(dynamic dyn) {
    return dyn == Null ? 0 : dyn as int;
  }
}
