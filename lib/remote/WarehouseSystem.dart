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
  Future<Results?> _interact<Results>(
      Future<Results>? Function(MySqlConnection? connection) action) async {
    MySqlConnection? connection;
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
  Future<MySqlConnection?> connect() async {
    var settings = new ConnectionSettings(
        host: WMSMySql.host,
        port: WMSMySql.port,
        user: WMSMySql.user,
        password: WMSMySql.pass,
        db: WMSMySql.db);

    return await MySqlConnection.connect(settings);
  }

  Future<Product> getProduct(String ean) async {
    Results? results;
    var sql = SQLQuery.getProduct(ean);
    results = await _interact((connection) => connection?.query(sql));
    print("ean" + " " + results.toString());
    var p = Deserialization.toProduct(results);
    return p;
  }

  Future<List<String>> getSKUSuggestions(String text) async {
    var results = await _interact(
        (connection) => connection?.query(SQLQuery.getSKUSuggestions(text)));

    return Deserialization.toSkus(results);
  }

  Future<List<T>?> attribute<T>(int id, String attribute) async {
    var results = await _interact((connection) =>
        connection?.query((SQLQuery.getAttribute(id.toString(), attribute))));

    print(attribute + " " + results.toString());

    if (results == null) {
      return List.empty();
    }

    return results.map<T>((e) => e[0]).toList();
  }

  Future<dynamic>? disconnect(MySqlConnection? connection) =>
      connection?.close();
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
    print("warehousesystem get " + attributeCode);

    if (attributeCode == Attribute.sku) {
      return _skuQuery(entityId);
    }

    if (attributeCode == Attribute.images) {
      return _imagesQuery(entityId);
    }

    return _attributeQuery(entityId, attributeCode);
  }

  static _attributeQuery(String entityId, String attributeCode) =>
      "SELECT `catalog_product_entity_varchar`.`value` FROM `catalog_product_entity_varchar` WHERE `catalog_product_entity_varchar`.`attribute_id` IN (SELECT `eav_attribute`.`attribute_id` FROM `eav_attribute` WHERE `eav_attribute`.`attribute_code` = '$attributeCode') AND `catalog_product_entity_varchar`.`entity_id` = '$entityId' AND `catalog_product_entity_varchar`. `store_id` = '0';";
  // 'sku' can't be used with the generic attribute query
  static _skuQuery(String entityId) =>
      "SELECT `catalog_product_entity`.`sku`FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` = '$entityId'";
  static _imagesQuery(String entityId) =>
      "SELECT `catalog_product_entity_media_gallery`.`value` FROM `catalog_product_entity_media_gallery`, `catalog_product_entity_media_gallery_value` WHERE `catalog_product_entity_media_gallery`.`entity_id` IN (SELECT `catalog_product_relation`.`parent_id` FROM `catalog_product_relation` WHERE `catalog_product_relation`.`child_id` = '$entityId') AND `catalog_product_entity_media_gallery`.`value_id` = `catalog_product_entity_media_gallery_value`.`value_id` AND (`catalog_product_entity_media_gallery_value`.`position` = '1' OR `catalog_product_entity_media_gallery_value`.`position` = '2') ORDER BY `catalog_product_entity_media_gallery_value`.`position` ASC;";
}
