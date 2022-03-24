import 'package:wms_app/models/attributes.dart';

class SQLQuery {
  static String fetchProduct(String ean) =>
      "SELECT `catalog_product_entity`.`entity_id` FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` IN (SELECT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283' AND `value` = '" +
      ean +
      "') ORDER BY `entity_id` DESC LIMIT 1;";

  // SELECT `catalog_product_entity`.`sku`FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` = '<entity id>'
  static String fetchProductSuggestions(String sku) {
    // LIMIT 10
    return "SELECT `entity_id` FROM `catalog_product_entity` WHERE `sku` LIKE '%" +
        sku +
        "%' AND `entity_id` NOT IN (SELECT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283') LIMIT 20";
  }

  // see table in magento: https://www.katsumi.se/index.php/yuDuMinD/catalog_product_attribute/index/key/e036b264c18e46443f82569948fa575c/

  static String fetchAttribute(String entityId, Attribute attribute) {
    print("warehousesystem get " + attribute);

    if (attribute == Attributes.sku) {
      return _skuQuery(entityId);
    }

    if (attribute == Attributes.images) {
      return _imagesQuery(entityId);
    }
    return _attributeQuery(entityId, attribute);
  }

  static _attributeQuery(String entityId, String attributeCode) =>
      "SELECT `catalog_product_entity_varchar`.`value` FROM `catalog_product_entity_varchar` WHERE `catalog_product_entity_varchar`.`attribute_id` IN (SELECT `eav_attribute`.`attribute_id` FROM `eav_attribute` WHERE `eav_attribute`.`attribute_code` = '$attributeCode') AND `catalog_product_entity_varchar`.`entity_id` = '$entityId' AND `catalog_product_entity_varchar`. `store_id` = '0';";
  // 'sku' can't be used with the generic attribute query
  static _skuQuery(String entityId) =>
      "SELECT `catalog_product_entity`.`sku`FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` = '$entityId'";
  static _imagesQuery(String entityId) =>
      "SELECT `catalog_product_entity_media_gallery`.`value` FROM `catalog_product_entity_media_gallery`, `catalog_product_entity_media_gallery_value` WHERE `catalog_product_entity_media_gallery`.`entity_id` IN (SELECT `catalog_product_relation`.`parent_id` FROM `catalog_product_relation` WHERE `catalog_product_relation`.`child_id` = '$entityId') AND `catalog_product_entity_media_gallery`.`value_id` = `catalog_product_entity_media_gallery_value`.`value_id` AND (`catalog_product_entity_media_gallery_value`.`position` = '1' OR `catalog_product_entity_media_gallery_value`.`position` = '2') ORDER BY `catalog_product_entity_media_gallery_value`.`position` ASC;";

  static setEAN(String entityId, String ean) =>
      "INSERT INTO `catalog_product_entity_varchar` (`entity_type_id`, `attribute_id`, `store_id`, `entity_id`, `value`) VALUES ('4', '283', '0', '$entityId', '$ean');";

  //static _updateEAN(String entityId, String ean) =>
  //    "UPDATE `catalog_product_entity_varchar` SET `value` = '$ean' WHERE `catalog_product_entity_varchar`.`attribute_id` = '283' AND `catalog_product_entity_varchar`.`entity_id` = '$entityId'";

  static increaseAmountOfProduct(String entityId) =>
      "UPDATE `cataloginventory_stock_item` SET `qty` = `qty` + '1' WHERE `product_id` = '$entityId';";

  static findShelf(String scanData) =>
      "SELECT `value` FROM `catalog_product_entity_varchar` WHERE `value` LIKE '%$scanData%' AND `attribute_id` = '198';";
  static quantity(String entityId) =>
      "SELECT `qty` FROM `cataloginventory_stock_item` WHERE `cataloginventory_stock_item`.`product_id` = '$entityId';";

  static setShelf(String entityId, String shelf) =>
      "UPDATE `catalog_product_entity_varchar` SET `value` = '$shelf' WHERE `catalog_product_entity_varchar`.`entity_id` = '$entityId' AND `catalog_product_entity_varchar`.`attribute_id` = 198;";
}

  /*
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
*/