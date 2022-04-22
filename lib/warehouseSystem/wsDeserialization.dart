import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/flexibleProduct.dart';
import 'package:wms_app/models/product.dart';

//
/*
class Deserialization {
  static List<Product> products(Results? results) {
    if (results == null || results.isEmpty) {
      return List.empty();
    }

    var ids = results.map((e) => (e[0] as int)).toList();
    return ids.map((e) => Product(e)).toList();
  }

  static double quantity(Results? results) {
    if (results == null || results.isEmpty) {
      return 0;
    }

    var ids = results.map((e) => (e[0] as double)).toList();

    if (ids.isEmpty) {
      return 0;
    }

    return ids[0];
  }
  /*
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
  */
}
*/