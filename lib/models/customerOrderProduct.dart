import 'package:wms_app/types.dart';
import 'package:wms_app/utils.dart';

class CustomerOrderProduct {
  Map<String, dynamic> _attributes = _empty;
  CustomerOrderProduct(this._attributes);
  CustomerOrderProduct.empty();

  String get id => _attributes["id"];
  String get name => _attributes["name"];
  String get displayId => _attributes["displayId"];
  String get productId => _attributes["productId"];
  String get qtyOrdered => _attributes["qtyOrdered"];
  int? get qtyPicked => Utils.toNullableInt(_attributes["qtyPicked"]);

  static Model get _empty => {
        "id": "",
        "name": "",
        "displayId": "",
        "productId": "",
        "qtyOrdered": "",
        "qtyPicked": ""
      };

  bool get isEmpty => Utils.isNullOrEmpty(_attributes[id]);
}
