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
}
