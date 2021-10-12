import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';

//

class Deserialization {
  /*
  static List<Product> toProducts(Results results) {
    // I see no reason to error handle here, I'ts better if it crash so I get told directly
    // when I (potentially) pass in wrong 'Results' object

    if (results == null) {
      return null;
    }

    return results
        .map((r) => new Product(r[0], r[1], r[2], r[3], r[4]))
        .toList();
  }
  */

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
    var suggestions = results.map<String>((e) => e[0]).toList();
    return suggestions;
  }
}
