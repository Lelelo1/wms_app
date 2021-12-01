// a product model that can keep state but can sync with flexibleProduct in a good way
/*
import 'package:wms_app/models/product.dart';
import 'package:wms_app/utils.dart';

// could be seen as a writeable product
class FlexibleProduct {
  Product _product = Product.empty(); // flexible

  FlexibleProduct(int id) {
    _product = Product(id);
  }

  FlexibleProduct.empty();

  int id() => _product.id;
  bool exists() => id() > 0;

  // 'cached' local held properties...
  String _ean = Utils.defaultString(null);
  Future<String> ean() =>
      _product.exists() ? _product.getEAN() : Future.sync(() => _ean);

  FlexibleProduct.fromEAN(String ean) {
    this._ean = ean;
  }

  Future<String> sku() => _product.getSKU();
  Future<String> shelf() => _product.getShelf();
  Future<String> name() => _product.getName();
  Future<List<String>> images() => _product.getImages();

  // prints cached values
  Future<String> futureToString() async {
    return Future.sync(
        () => "futureToString no implementation on 'FliexibleProduct'");
  }
}
*/