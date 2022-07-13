import 'package:wms_app/types.dart';

class CustomerOrder {
  Map<String, dynamic> _attribute = _empty;
  CustomerOrder._(this._attribute);

  static Model get _empty => {
        "id": null,
        "ean": null,
        "name": null,
        "shelf": null,
        "sku": null,
        "image_front": null,
        "image_back": null,
        "qty": null
      };
}
