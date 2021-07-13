import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/remote/database/abstractProductsSource.dart';
import 'package:wms_app/remote/database/mockProductsSource.dart';

class WorkStore {
  AbstractProductsSource abstractSource = MockProductsSource();

  Future<Sequence> getCollection() async {
    return Sequence(await abstractSource.getProducts());
  }

  Sequence getRegistration() {
    return null;
  }

  Sequence getCounting() {
    return null;
  }
}
