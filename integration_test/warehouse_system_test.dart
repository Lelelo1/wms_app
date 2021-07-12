//import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wms_app/remote/database/productsSource.dart';

// https://flutter.dev/docs/testing/integration-tests
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
/*
  test("ssh_test_connection", () async {
    SSH.openConnection();
    var sshConnectionStatus = await SSH.connecting;
    //print("connected to warehouse system: " + connected.toString());
    expect(sshConnectionStatus, "session_connected");
  });
  */
  test("database_test_connection", () async {
    //await SSH.connecting;

    ProductsSource.connect();
    var databaseConnection = await ProductsSource.connecting;

    var results = await databaseConnection.query(SQLQuery.barcodeNeeded);
    print("recievied..");
    print(results.toString());

    expect(results != null, true);
  });
/*
  test("database_insert_barcode", () async {
    //await SSH.connecting;

    ProductsSource.connect();
    var databaseConnection = await ProductsSource.connecting;

    var results = await databaseConnection.query(SQLQuery.barcodeNeeded);
    print("recievied..");
    print(results);

    expect(results != null, true);
  });
*/

  /*
  testWidgets("failing test example", (WidgetTester tester) async {
    expect(2 + 2, equals(5));
  });
  */
}

// description in test methdo just logs to console. print logs red text outside the test methods
