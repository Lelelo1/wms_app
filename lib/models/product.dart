import 'package:flutter/widgets.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/utils.dart';
import '../types.dart';

class Product {
  Map<String, dynamic> _attributes = _emptyAttributes;
  Product._(this._attributes);

  int get id => int.parse(Utils.getAndDefaultAs(_attributes["@id"], "0"));

  int get ean => int.parse(Utils.getAndDefaultAs(_attributes["@ean"], "0"));

  String get name => Utils.getAndDefaultAs(_attributes["@name"], "");

  String get shelf => Utils.getAndDefaultAs(_attributes["@shelf"], "");

  String get sku => Utils.getAndDefaultAs(_attributes["@sku"], "");

// SELECT @id, @ean, @name, @shelf, @sku, @image_front, @image_back, @qty;
  String get frontImage =>
      toKatsumiImage(Utils.getAndDefaultAs(_attributes["@image_front"], ""));

  String get backImage =>
      toKatsumiImage(Utils.getAndDefaultAs(_attributes["@image_back"], ""));

  String toKatsumiImage(String? image) {
    if (Utils.isNullOrEmpty(image)) {
      return "";
    }

    return "https://www.katsumi.se/media/catalog/product/" + (image as String);
  }

  double get qty =>
      double.parse(Utils.getAndDefaultAs(_attributes["@qty"], "0"));

  bool get exists => id != 0;

  static String query() =>
      "SELECT @id := v.entity_id FROM catalog_product_entity_varchar v JOIN catalog_product_entity p ON v.entity_id = p.entity_id WHERE v.attribute_id = '283' AND v.value = '889501092529' LIMIT 1;SELECT @ean := v.value FROM catalog_product_entity_varchar v WHERE v.entity_id = @id AND v.attribute_id = '283' LIMIT 1;SELECT @sku := p.sku FROM catalog_product_entity p WHERE p.entity_id = @id;SELECT @name := `catalog_product_entity_varchar`.`value` FROM `catalog_product_entity_varchar` WHERE `catalog_product_entity_varchar`.`attribute_id` IN (SELECT `eav_attribute`.`attribute_id` FROM `eav_attribute` WHERE `eav_attribute`.`attribute_code` = 'name') AND `catalog_product_entity_varchar`.`entity_id` = @id AND `catalog_product_entity_varchar`. `store_id` = '0';SELECT @shelf := `catalog_product_entity_varchar`.`value` FROM `catalog_product_entity_varchar` WHERE `catalog_product_entity_varchar`.`attribute_id` IN (SELECT `eav_attribute`.`attribute_id` FROM `eav_attribute` WHERE `eav_attribute`.`attribute_code` = 'c2c_hyllplats') AND `catalog_product_entity_varchar`.`entity_id` = @id AND `catalog_product_entity_varchar`. `store_id` = '0';(SELECT @image_front := g.value FROM catalog_product_entity_media_gallery g, catalog_product_entity_media_gallery_value gv WHERE g.entity_id IN (SELECT r.parent_id FROM catalog_product_relation r WHERE r.child_id = @id) AND g.value_id = gv.`value_id` AND (gv.position = '1') ORDER BY gv.position ASC) LIMIT 1;(SELECT @image_back := g.value FROM catalog_product_entity_media_gallery g, catalog_product_entity_media_gallery_value gv WHERE g.entity_id IN (SELECT r.parent_id FROM catalog_product_relation r WHERE r.child_id = @id) AND g.value_id = gv.`value_id` AND (gv.position = '2') ORDER BY gv.position ASC) LIMIT 1;SELECT @qty := i.qty FROM cataloginventory_stock_item i WHERE i.product_id = @id;SELECT @id, @ean, @name, @shelf, @sku, @image_front, @image_back, @qty;";

/*
  static Future<List<Product>> fetch() async {
    var models = await WSInteract.remoteSql(query);

    return models.map((attributes) => Product._(attributes)).toList();
  }
*/

  static Future<Product> fetchFromEAN(String ean) async {
    var q = query().replaceFirstMapped("<>", (match) => ean);

    var models = await WSInteract.remoteSql(q);

    if (models.isEmpty) {
      return empty;
    }

    return models.map((attributes) => Product._(attributes)).first;
  }

  // SELECT @id, @ean, @name, @shelf, @sku, @image_front, @image_back, @qty;
  static Model get _emptyAttributes => {
        "@id": null,
        "@ean": null,
        "@name": null,
        "@shelf": null,
        "@sku": null,
        "@image_front": null,
        "@image_back": null,
        "@qty": null
      };
  static Product get empty => Product._(_emptyAttributes);

  @override
  String toString() {
    return _attributes.toString();
  }
}
