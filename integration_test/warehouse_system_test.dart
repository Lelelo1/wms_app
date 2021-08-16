//import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mysql1/mysql1.dart';
import 'package:wms_app/remote/productsSource.dart';
import 'package:wms_app/remote/deserialization.dart';

// https://flutter.dev/docs/testing/integration-tests
void main() {
  // from deprecated package: https://pub.dev/packages/integration_test
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  MySqlConnection databaseConnection;
  test("database_test_connection", () async {
    //await SSH.connecting;

    ProductsSource.connect();
    databaseConnection = await ProductsSource.connecting;
    var result =
        await databaseConnection.query("SELECT 'Something sweet'"); // do any
    // Something sweet" is standard response (atleast in mysql): https://stackoverflow.com/questions/4957155/mysql-testing-connection-with-query
    expect(result?.toList()[0]?.toList()[0] == "Something sweet", true);
  });

  test("database_test_products", () async {
    //await SSH.connecting;
    var response =
        await databaseConnection.query(SQLQuery.productsFeminint); // do any
    var products = Deserialization.toProducts(response);

    //products.forEach((p) => print(p));

    expect(products.length > 0, true);
  });

// "database_insert_barcode" eg

  /*
  testWidgets("failing test example", (WidgetTester tester) async {
    expect(2 + 2, equals(5));
  });
  */
}

// there is annoying red lines when starting VMServiceFlutterDriver and I have never understood how to get rid of them
