import 'package:wms_app/models/abstractProduct.dart';
import 'package:wms_app/models/product.dart';

class MockProduct extends AbstractProduct {
  @override
  int id = 0;
  String ean = "";
  List<String> images = List.empty();
  String name = "";
  double quantity = 0;
  String sku = "";
  String shelf = "";

  MockProduct(this.id, this.ean, this.images, this.name, this.quantity,
      this.sku, this.shelf);

  @override
  Future<String> getEAN() => Future.sync(() => ean);

  @override
  Future<List<String>> getImages() => Future.sync(() => images);

  @override
  Future<String> getName() => Future.sync(() => name);

  @override
  Future<double> getQuanity() => Future.sync(() => quantity);

  @override
  Future<String> getSKU() => Future.sync(() => sku);

  @override
  Future<String> getShelf() => Future.sync(() => shelf);

  @override
  Future<void> setEAN(String ean) async {
    Future.sync(() => this.ean = ean);
  }
}
