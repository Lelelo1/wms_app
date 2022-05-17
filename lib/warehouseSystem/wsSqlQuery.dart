import 'package:wms_app/models/attributes.dart';
import 'package:wms_app/warehouseSystem/wsMapping.dart';

class WSSQLQueries {
  Mapping mapping;
  WSSQLQueries(this.mapping);

  String fetchProduct(String ean) => mapping.fetchProductSubject.sql((s) =>
      "SELECT `${s.tables[0]}`.`${s.attributes[0].name}` FROM `${s.tables[0]}` WHERE `${s.tables[0]}`.`${s.attributes[0].name}` IN (SELECT `${s.attributes[0].name}` FROM `${s.tables[1]}` WHERE `${s.attributes[1].name}`  AND `value` = '$ean') ORDER BY `${s.attributes[0].name}` DESC LIMIT 1;");

  /*
  static String fetchProduct(String ean) =>
      "SELECT `catalog_product_entity`.`entity_id` FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` IN (SELECT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283' AND `value` = '" +
      ean +
      "') ORDER BY `entity_id` DESC LIMIT 1;";
  */

  // SELECT `catalog_product_entity`.`sku`FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` = '<entity id>'
  String fetchProductSuggestions(String sku) {
    // LIMIT 10
    return "SELECT `entity_id` FROM `catalog_product_entity` WHERE `sku` LIKE '%" +
        sku +
        "%' AND `entity_id` NOT IN (SELECT `entity_id` FROM `catalog_product_entity_varchar` WHERE `attribute_id` = '283') LIMIT 20";
  }

  // see table in magento: https://www.katsumi.se/index.php/yuDuMinD/catalog_product_attribute/index/key/e036b264c18e46443f82569948fa575c/

  String fetchAttribute(String entityId, KatsumiAttribute attribute) {
    print("warehousesystem get " + attribute);

    if (attribute == KatsumiAttributes.sku) {
      return _skuQuery(entityId);
    }

    if (attribute == KatsumiAttributes.images) {
      return _imagesQuery(entityId);
    }
    return _attributeQuery(entityId, attribute);
  }

  _attributeQuery(String entityId, String attributeCode) =>
      "SELECT `catalog_product_entity_varchar`.`value` FROM `catalog_product_entity_varchar` WHERE `catalog_product_entity_varchar`.`attribute_id` IN (SELECT `eav_attribute`.`attribute_id` FROM `eav_attribute` WHERE `eav_attribute`.`attribute_code` = '$attributeCode') AND `catalog_product_entity_varchar`.`entity_id` = '$entityId' AND `catalog_product_entity_varchar`. `store_id` = '0';";
  // 'sku' can't be used with the generic attribute query
  _skuQuery(String entityId) =>
      "SELECT `catalog_product_entity`.`sku`FROM `catalog_product_entity` WHERE `catalog_product_entity`.`entity_id` = '$entityId'";
  _imagesQuery(String entityId) =>
      "SELECT `catalog_product_entity_media_gallery`.`value` FROM `catalog_product_entity_media_gallery`, `catalog_product_entity_media_gallery_value` WHERE `catalog_product_entity_media_gallery`.`entity_id` IN (SELECT `catalog_product_relation`.`parent_id` FROM `catalog_product_relation` WHERE `catalog_product_relation`.`child_id` = '$entityId') AND `catalog_product_entity_media_gallery`.`value_id` = `catalog_product_entity_media_gallery_value`.`value_id` AND (`catalog_product_entity_media_gallery_value`.`position` = '1' OR `catalog_product_entity_media_gallery_value`.`position` = '2') ORDER BY `catalog_product_entity_media_gallery_value`.`position` ASC;";

  setEAN(String entityId, String ean) =>
      "INSERT INTO `catalog_product_entity_varchar` (`entity_type_id`, `attribute_id`, `store_id`, `entity_id`, `value`) VALUES ('4', '283', '0', '$entityId', '$ean');";

  //static _updateEAN(String entityId, String ean) =>
  //    "UPDATE `catalog_product_entity_varchar` SET `value` = '$ean' WHERE `catalog_product_entity_varchar`.`attribute_id` = '283' AND `catalog_product_entity_varchar`.`entity_id` = '$entityId'";

  List<String> increaseAmountOfProduct(String entityId) => [
        "UPDATE `cataloginventory_stock_item` SET `qty` = CASE WHEN `qty` > '9000' THEN '1' ELSE `qty` + '1' END WHERE `product_id` = '$entityId';",
        "UPDATE `cataloginventory_stock_status` SET `stock_status` = '1' WHERE `product_id` = '$entityId';",
        "UPDATE `cataloginventory_stock_status_idx` SET `stock_status` = '1' WHERE `product_id` = '$entityId';",
        "UPDATE `cataloginventory_stock_item` SET `is_in_stock` = '1' WHERE `product_id` = '$entityId';"
      ];

  findShelf(String scanData) =>
      "SELECT `value` FROM `catalog_product_entity_varchar` WHERE `value` LIKE '%$scanData%' AND `attribute_id` = '198';";
  quantity(String entityId) =>
      "SELECT `qty` FROM `cataloginventory_stock_item` WHERE `cataloginventory_stock_item`.`product_id` = '$entityId';";

  setShelf(String entityId, String shelf) =>
      "UPDATE `catalog_product_entity_varchar` SET `value` = '$shelf' WHERE `catalog_product_entity_varchar`.`entity_id` = '$entityId' AND `catalog_product_entity_varchar`.`attribute_id` = 198;";

  // customer orders..

  WSCustomerOrderQueries customerOrders = WSCustomerOrderQueries();
}

class WSCustomerOrderQueries {
  String getAvailableCustomerOrders() =>
      "SELECT entity_id FROM `sales_flat_order` WHERE status = 'pending' OR status = 'pendingpreorder' OR status = 'processing' OR status = 'processingpreorder' AND `sales_flat_order`.`entity_id` IN (SELECT order_id FROM sales_flat_order_item WHERE qty_picked <> NULL) ORDER BY created_at DESC LIMIT 12";

  String getIsCustomerChosen() => "";

  String getCustomerFirstName(String orderId) =>
      "SELECT customer_firstname FROM `sales_flat_order` WHERE entity_id = '$orderId'";

  String getCustomerLastName(String orderId) =>
      "SELECT customer_lastname FROM `sales_flat_order` WHERE entity_id = '$orderId'";

  String getProducts(String orderId) =>
      "SELECT product_id FROM `sales_flat_order_item` WHERE order_id = '$orderId' AND product_type = 'simple'";
  String getIncrementId(String orderId) =>
      "SELECT increment_id FROM `sales_flat_order` WHERE entity_id = $orderId";
  String getProductQuantity(String orderId, String productId) =>
      "SELECT qty_ordered FROM `sales_flat_order_item` WHERE order_id = '$orderId' AND product_id = '$productId'";
  String setQtyPicked(String orderId, String productId, int? qtyPicked) {
    if (qtyPicked == null) {
      return "UPDATE `sales_flat_order_item` SET `qty_picked` = NULL WHERE order_id = '$orderId' AND product_id = '$productId'";
    }
    return "UPDATE `sales_flat_order_item` SET `qty_picked` = '$qtyPicked' WHERE order_id = '$orderId' AND product_id = '$productId'";
  }

  String getQtyPicked(String orderId, String productId) =>
      "SELECT `qty_picked` FROM `sales_flat_order_item` WHERE order_id = '$orderId' AND product_id = '$productId' ";
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