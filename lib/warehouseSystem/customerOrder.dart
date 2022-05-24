import 'package:wms_app/models/model.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/widgets/wmsCardChecker.dart';

class CustomerOrder implements Model, WMSCardCheckerProps {
  Map<String, dynamic> _attributes;
  CustomerOrder(this._attributes);

  int get id => _attributes["entity_id"];
  String get firstName => _attributes["customer_firstname"];
  String get lastName => _attributes["customer_lastname"];
  List<int> get products => _attributes["product_ids"];
  int get incrementId => _attributes["increment_id"];
  double get quanity => _attributes["qty_ordered"];
  int? get quantityPicked => _attributes["qty_picked"];

  @override
  // TODO: implement title
  String get title => firstName + " " + lastName;

  @override
  // TODO: implement subtitle
  String get subtitle => products.length.toString() + "st";

  @override
  // TODO: implement trailing
  String get trailing => incrementId.toString();

  @override
  // TODO: implement isChecked
  bool get isChecked => quantityPicked != null;

  @override
  // TODO: implement onChecked
  bool get onChecked => true;

  @override
  WMSCardCheckerProps Function() get create => () => CustomerOrder(_attributes);

  static Future<CustomerOrder> setQtyPicked(
      String orderId, String productId, int? qtyPicked) async {
    var value = qtyPicked == null ? "NULL" : '$qtyPicked';

    var sql = "UPDATE `sales_flat_order_item` SET `qty_picked` = "
        '$value'
        "  WHERE order_id = '$orderId' AND product_id = '$productId'";

    await WSInteract.remoteSql(sql);
  }
}
