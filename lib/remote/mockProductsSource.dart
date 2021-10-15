// varplocklista

// potentially create a mock, when showing to people and not being connected, to pin pointing problems
// etc

/
import 'abstractProductsSource.dart';

class MockProductsSource implements AbstractProductsSource {
  /
  // my own pattern, supported lazy fire and forget initialilization, but it's possible to awat the creation of all services vis there 'getAsync' method
  static Future<MockProductsSource> futureMockProductsSource;
  static void init() {
    // can be async
    futureMockProductsSource = Future(() => new MockProductsSource._());
    print("finished creating 'MockProductsSource'");
  }

  static Future<MockProductsSource> getAsync() async {
    return await futureMockProductsSource;
  }
*/

  List<Product> _products;

  MockProductsSource() {
    // private/protected: MockProductsSource._()
    /*
    _products = [
      Product("Fantasie Swim", "A8", 19282718, 3, 12),
      Product("Fantasy baddräckt", "A9", 3923181, 3, 35),
      Product("Standard bikini", "A10", 32987653, 2, null),
      Product("Mönstrad vally kupa", "C1", 76523718, 1, 163),
      Product("Bikiniöverdel", "C3", 182382, 1, 127),
      Product("Katsumi classic", "C4", 1238493, 1, null),
      Product("Palm Vally", "D1", 1223874, 2, null),
      Product("Mönstrad överdel", "D3", 1236483, 2, 21)
    ];
    */
  }

  @override
  Future<List<Product>> getProducts() {
    return Future.value(_products);
  }

  /*
  static List<Product> get([int count]) {
    return _products;
  }
  */
}

*/
