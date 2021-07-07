//import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wms_app/remote/database/MySQLConnector.dart';
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

    MySQLConnector.connect();
    var databaseConnection = await MySQLConnector.connecting;
    var results = await databaseConnection.query("show processlist");

    print(results.fields[0].name);
    print(results.fields[0].name);

    expect(results?.length > 0, true);
  });
  /*
  testWidgets("failing test example", (WidgetTester tester) async {
    expect(2 + 2, equals(5));
  });
  */
}

// description in test methdo just logs to console. print logs red text outside the test methods
