import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/deserialization.dart';
import 'package:wms_app/secrets.dart';

import '../utils.dart';

// https://pub.dev/packages/mysql1
class WarehouseSystem /*implements AbstractProductsSource */ {
  Future<T> _interact<T>(
      Future<T> Function(MySqlConnection connection) action) async {
    print("interact");
    MySqlConnection connection;
    try {
      connection = await connect();
    } on Exception catch (exception) {
      print("failed interact. did not connect...");
      print(exception.toString());
      return null;
    }
    print("interact got connection, preforming action");
    var result = await action(connection);
    disconnect(connection);
    return result;
  }

  // needs internet permission android real device, otherwise: 'SocketException: OS Error: Connection refused'
  // https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan
  // such permission is granted on install time: https://developer.android.com/training/basics/network-ops/connecting
  Future<MySqlConnection> connect() async {
    var settings = new ConnectionSettings(
        host: MySql.host,
        port: MySql.port,
        user: MySql.user,
        password: MySql.pass,
        db: MySql.db);

    return await MySqlConnection.connect(settings);
  }

  Future<Product> getProduct(String ean) async {
    Results results;
    var sql = SQLQuery.getProduct(ean);
    results = await _interact((connection) => connection.query(sql));
    return Deserialization.toProduct(results);
  }

  Future<List<String>> getSKUSuggestions(String text) async {
    var results = await _interact(
        (connection) => connection.query(SQLQuery.getSKUSuggestions(text)));

    return Deserialization.toSkus(results);
  }

  attribute<T>(int id, Attribute attribute) async {
    var results = await _interact((connection) => connection
        .query((SQLQuery.getAttribute(id.toString(), attribute.toString()))));

    if (Utils.isNullOrEmpty(results)) {
      return null;
    }

    return results.map<T>((e) => e[0]).first;
  }

  Future<void> disconnect(MySqlConnection connection) => connection.close();
}

class SQLQuery {
  // note entity_id
  /*
  static String barcodeNeeded =
      "SELECT DISTINCT `catalog_product_entity`.`entity_id` as 'entity_id' FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` NOT IN (SELECT DISTINCT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283') AND `catalog_product_entity`.`type_id` = 'simple' ORDER BY `catalog_product_entity`.`entity_id` DESC;";
      */
  //static String getProduct(String ean) => "SELECT ..."
  static String barcodeNeeded =
      "SELECT DISTINCT `catalog_product_entity`.`entity_id` as 'entity_id' FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` NOT IN (SELECT DISTINCT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283') AND `catalog_product_entity`.`type_id` = 'simple' ORDER BY `catalog_product_entity`.`entity_id` DESC;";
  String shelfBarcodeRegistration = "";

// temp below, just to see what ui looks loke with the data
// int ean, int sku, String shelf, String name
  static String productsFeminint =
      "SELECT DISTINCT ean_code, sku, c2c_hyllplats, name, image FROM catalog_product_flat_14 LIMIT 28;";

  static String getProduct(String ean) =>
      "SELECT `catalog_product_entity`.`entity_id` FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` IN (SELECT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283' AND `value` = '" +
      ean +
      "') ORDER BY `entity_id` DESC LIMIT 1;";
  static String getSKUSuggestions(String sku) {
    // LIMIT 10
    return "SELECT `sku` FROM `catalog_product_entity` WHERE `sku` LIKE '%" +
        sku +
        "%' LIMIT 20";
  }

  // see table in magento: https://www.katsumi.se/index.php/yuDuMinD/catalog_product_attribute/index/key/e036b264c18e46443f82569948fa575c/

  static String getAttribute(String entityId, String attributeCode) {
    return "SELECT `catalog_product_entity_varchar`.`value` FROM `catalog_product_entity_varchar` WHERE `catalog_product_entity_varchar`.`attribute_id` IN (SELECT `eav_attribute`.`attribute_id` FROM `eav_attribute` WHERE `eav_attribute`.`attribute_code` = '$attributeCode') AND `catalog_product_entity_varchar`.`entity_id` = '$entityId' AND `catalog_product_entity_varchar`. `store_id` = '0';";
  }
}
