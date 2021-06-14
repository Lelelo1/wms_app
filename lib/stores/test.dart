
// varplocklista
import 'package:wms_app/models/product.dart';

class Products {
  static List<Product> _products = [
    Product("Fantasie Swim", "A8", 19282718, 3),
    Product("Fantasy baddräckt", "A9", 3923181, 3),
    Product("Standard bikini", "A10", 32987653, 2),
    Product("Mönstrad vally kupa", "C1", 76523718, 1),
    Product("Bikiniöverdel", "C3", 182382, 1),
    Product("Katsumi classic", "C4", 1238493, 1),
    Product("Palm Vally", "D1", 1223874, 2),
    Product("Mönstrad överdel", "D3", 1236483, 2)
    ];
  static List<Product> get([int count]) {
    return _products;
  }
}