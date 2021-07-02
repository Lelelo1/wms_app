import 'package:mysql1/mysql1.dart';
import 'dart:io' show Platform;

// https://pub.dev/packages/mysql1
class MySQLConnector {
  static ConnectionSettings settings;

  static ConnectionSettings createConnectionSettings() {
    var password =
        Platform.environment["WMSAppTestingSQLDatabseConnectionPassword"];
    return new ConnectionSettings(
        host: '127.0.0.1',
        port: 3306,
        user: "lelelo1",
        password: password,
        db: "sakila");
  }

  static void test() {
    if (settings == null) {
      settings = createConnectionSettings();
      print("created database connection settings");
    }
  }

  void printAllProducts() {}
}
