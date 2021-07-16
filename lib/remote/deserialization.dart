import 'package:flutter_driver/flutter_driver.dart';
import 'package:wms_app/models/product.dart';
import 'package:reflectable/reflectable.dart';

class MyReflectable extends Reflectable {
  const MyReflectable() : super(invokingCapability);
}

const myReflectable = MyReflectable();

class deserialization {
  static List<Product> ToProducts(Result result) {
    var mirror = myReflectable.reflectType(Product);
    print((Product).toString() +
        " has " +
        mirror.typeVariables.length.toString() +
        " fields");
    return null;
  }
}
