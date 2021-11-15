import 'package:wms_app/models/product.dart';

class Sequence {
  List<Product> products;
  Iterator<Product> iterator() => products.iterator;

  Sequence(this.products) {
    iterator().moveNext();
  }
}
