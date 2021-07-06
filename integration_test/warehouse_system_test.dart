//import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wms_app/database/mySQLConnector.dart';

// https://flutter.dev/docs/testing/integration-tests
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test("my description", () {
    var connected = MySQLConnector.connect();
    print("connected to warehouse system: " + connected.toString());
    expect(true, connected);
  });

  /*
  testWidgets("failing test example", (WidgetTester tester) async {
    expect(2 + 2, equals(5));
  });
  */
}
