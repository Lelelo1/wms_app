import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/flexibleProduct.dart';
import 'package:wms_app/models/product.dart';

//

class Deserialization {
  static Product toProduct(Results? results, String ean) {
    if (results == null || results.isEmpty) {
      return Product.empty();
    }

    var ids = results.map((e) => (e[0] as int)).toList();
    print("ids...");
    ids.forEach((element) {
      print(element.toString());
    });
    return Product(ids[0]);
  }

  static List<String> toSkus(Results? results) {
    if (results == null || results.isEmpty) {
      return List.empty();
    }
    //why is sku prepended with space, it makes it look like padding is wrong
    var suggestions = results.map<String>((e) {
      var sku = e[0];
      //print("sku...");
      //print(sku);
      return sku;
    }).toList();
    return suggestions;
  }
}
