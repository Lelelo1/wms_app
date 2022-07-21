import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/types.dart';
import 'package:wms_app/warehouseSystem/customerOrder.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/warehouseSystem/wsSqlQuery.dart';
import "package:collection/collection.dart";

class CustomerOrderProduct {
  Map<String, dynamic> _attribute = _empty;
  CustomerOrderProduct._(this._attribute);

  String get id => _attribute["id"];
  String get name => _attribute["name"];
  String get displayId => _attribute["displayId"];
  String get productId => _attribute["productId"];
  String get qtyOrdered => _attribute["qtyOrdered"];
  String get qtyPicked => _attribute["qtyPicked"];

  static Model get _empty => {
        "id": null,
        "name": null,
        "displayId": null,
        "productId": null,
        "qtyOrdered": null,
        "qtyPicked": null
      };

  static Future<List<CustomerOrder>> fetchCustomerOrders() async {
    var models = await WSInteract.remoteSql(CustomerOrderQueries.many());

    return models
        .map((e) => CustomerOrderProduct._(e))
        .groupListsBy((e) => e.id)
        .values
        .map((e) => CustomerOrder(e))
        .toList();
  }
}
