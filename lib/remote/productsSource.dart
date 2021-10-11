import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/archivedProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/remote/deserialization.dart';
import 'package:wms_app/secrets.dart';

// https://pub.dev/packages/mysql1
class ProductsSource /*implements AbstractProductsSource */ {
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

  /* // used fetching aribtary products 
  @override
  Future<List<Product>> getProducts(MySqlConnection connection) async {
    // assume any response is given with internet connection

    print("connected to warehouse system");

    Results results;
    try {
      results = await connection.query(SQLQuery.productsFeminint);
    } catch (exc) {
      print("failed sql error of " +
          SQLQuery.productsFeminint +
          ". exc: " +
          exc.toString());
    }

    print("got results from warehouse system: " + results.length.toString());
    if (results == null) {
      return null;
    }

    // should result in empty products list when there are no items in the databse on that query
    return Deserialization.toProducts(results);
  }
*/
  Future<Product> getProduct(MySqlConnection connection, String ean) async {
    Results results;
    var sql = SQLQuery.getProduct(ean);
    try {
      results = await connection.query(sql);
    } catch (exc) {
      print("failed sql error of " + sql + ". exc: " + exc.toString());
    }

    return Deserialization.toProduct(results);
  }

  Future<List<String>> getSKUSuggestions(
      MySqlConnection connection, String sku) async {
    var results = await connection.query(SQLQuery.getSKUSuggestions(sku));

    return Deserialization.toSkus(results);
  }

  Future<void> disconnect(MySqlConnection connection) => connection.close();
}

class SQLQuery {
  // returns entity_id's aka product id
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
  static String getSKUSuggestions(String sku) =>
      "SELECT `sku` FROM `catalog_product_entity` WHERE `sku` LIKE '%[sku_variable]%'";
}
