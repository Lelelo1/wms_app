import 'package:event/event.dart';

abstract class AbstractProduct extends EventArgs {
  abstract int id;
  Future<String> getEAN();
  Future<String> getSKU();
  Future<String> getShelf();
  Future<double> getQuanity();
  Future<String> getName();
  Future<List<String>> getImages();

  static const assignShelf = "BEST";

  //static defaultConverterString(String? value, [String to = '']) => value ?? to;
  String firstStringDefaultTo(List<String> values, [String to = '']) {
    if (values.isEmpty) {
      return to;
    }

    var value = values.first;
    if (value.isEmpty) {
      return to;
    }

    return value;
  }

  double firstDoubleDefaultTo(List<double> values, [double to = 0]) {
    if (values.isEmpty) {
      return to;
    }

    return values.first;
  }
}
