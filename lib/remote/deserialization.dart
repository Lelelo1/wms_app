import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';

//

class Deserialization {
  static Product toProduct(Results results) {
    if (results == null || results.isEmpty) {
      return null;
    }
    return results.map((e) => Product(e[0])).first;
  }

  static List<String> toSkus(Results results) {
    if (results == null || results.isEmpty) {
      return null;
    }
    //why is sku prepended with space, it makes it look like padding is wrong
    var suggestions = results.map<String>((e) {
      var sku = e[0];
      print("sku...");
      print(sku);
      return sku;
    }).toList();
    return suggestions;
  }
}
