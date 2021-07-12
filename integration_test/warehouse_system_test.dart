//import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wms_app/remote/database/productsSource.dart';
import 'package:wms_app/remote/ssh.dart';


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
    print(results);

    expect(results != null, true);
  });

// get producrs missing ian code: SELECT DISTINCT `catalog_product_entity`.`entity_id` as "entity_id" FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` NOT IN (SELECT DISTINCT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283') ORDER BY `catalog_product_entity`.`entity_id` DESC;

  /*
  testWidgets("failing test example", (WidgetTester tester) async {
    expect(2 + 2, equals(5));
  });
  */
}

// description in test methdo just logs to console. print logs red text outside the test methods
