import 'package:wms_app/types.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/utils/default.dart';

class CustomerOrderProduct {
  Map<String, dynamic> _attributes = _empty;
  CustomerOrderProduct(this._attributes);
  CustomerOrderProduct.empty();

  String get id => _attributes["id"];
  String get name => _attributes["name"];
  String get displayId => _attributes["displayId"];
  int get productId =>
      int.parse(Default.firstStringDefaultTo([_attributes["productId"], "0"]));
  String get qtyOrdered => _attributes["qtyOrdered"];
  int? get qtyPicked => Utils.toNullableInt(_attributes["qtyPicked"]);

  static Model get _empty => {
        "id": "",
        "name": "",
        "displayId": "",
        "productId": "0",
        "qtyOrdered": "",
        "qtyPicked": ""
      };

  bool get isEmpty => Utils.isNullOrEmpty(_attributes["id"]);
}
