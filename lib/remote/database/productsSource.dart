import 'package:mysql1/mysql1.dart';

import 'package:wms_app/secrets.dart';

// https://pub.dev/packages/mysql1
class ProductsSource {
  static Future<MySqlConnection> connecting;

  // needs internet permission android real device, otherwise: 'SocketException: OS Error: Connection refused'
  // https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan
  // such permission is granted on install time: https://developer.android.com/training/basics/network-ops/connecting
  static void connect() {
    var dbSecret = Secrets.mySQL;
    var settings = new ConnectionSettings(
        host: dbSecret.url,
        port: dbSecret.port,
        user: dbSecret.user,
        password: dbSecret.pass,
        db: dbSecret.database);

    connecting = MySqlConnection.connect(settings);
  }
}

class SQLQuery {
  // returns entity_id's aka product id
  /*
  static String barcodeNeeded =
      "SELECT DISTINCT `catalog_product_entity`.`entity_id` as 'entity_id' FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` NOT IN (SELECT DISTINCT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283') AND `catalog_product_entity`.`type_id` = 'simple' ORDER BY `catalog_product_entity`.`entity_id` DESC;";
      */
  static String barcodeNeeded =
      "SELECT DISTINCT `*` as 'entity_id' FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` NOT IN (SELECT DISTINCT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283') AND `catalog_product_entity`.`type_id` = 'simple' ORDER BY `catalog_product_entity`.`entity_id` DESC;";
  String shelfBarcodeRegistration = "";
}
