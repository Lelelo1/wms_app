import 'package:wms_app/models/product.dart';

class Sequence {
  List<Product> products;
  Iterator<Product> iterator;

  Sequence(List<Product> products) {
    print("sequence produtcs: " + products.toString());
    iterator = products.iterator;
    iterator.moveNext();
  }
}
