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
}
