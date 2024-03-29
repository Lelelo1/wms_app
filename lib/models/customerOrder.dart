import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/utils/arg.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/warehouseSystem/wsInteract.dart';
import 'package:wms_app/warehouseSystem/wsSqlQuery.dart';
import "package:collection/collection.dart";
import 'package:wms_app/widgets/wmsCardChecker.dart';

class CustomerOrder implements WMSCardCheckerProps {
  List<CustomerOrderProduct> customerOrderProducts = List.empty();
  CustomerOrder(this.customerOrderProducts);

  int get id => int.parse(customerOrderProducts.first.id);
  String get name => customerOrderProducts.first.name;
  String get displayId => customerOrderProducts.first.displayId;
  List<int> get productId =>
      customerOrderProducts.map((e) => e.productId).toList();
  double get qtyOrdered => customerOrderProducts
      .map((e) =>
          double.parse(Utils.getAndDefaultAs(e.qtyOrdered, 0.toString())))
      .sum;

  int? get qtyPicked => customerOrderProducts
      .map((e) => Default.intType.fromNullable(e.qtyPicked))
      .sum;

  bool get hasStarted =>
      customerOrderProducts
          .where((e) => Utils.defaultInt(e.qtyPicked) > 0)
          .length >=
      1;

  bool hasStartedPicking(CustomerOrderProduct c) =>
      c.qtyPicked != null && Utils.defaultInt(c.qtyPicked) > 0;

  Future<void> setQtyPickedAll(bool picked) async {
    int? qtyPicked = picked ? 0 : null;

    var futures = customerOrderProducts.map((e) {
      ;
      return WSInteract.remoteSql(CustomerOrderQueries.setQtyPicked(
          id.toString(), e.productId.toString(), qtyPicked));
    });

    await Future.wait(futures);
  }

  Future<void> setQtyPicked(CustomerOrderProduct c, bool isPicked) async {
    int? qtyPicked = isPicked ? 1 : 0;

    await WSInteract.remoteSql(CustomerOrderQueries.setQtyPicked(
        id.toString(), c.productId.toString(), qtyPicked));
  }

  static Future<List<CustomerOrder>> many() async {
    var models = await WSInteract.remoteSql(CustomerOrderQueries.many());

    return models
        .map((e) => CustomerOrderProduct(e))
        .groupListsBy((e) => e.id)
        .values
        .map((e) => CustomerOrder(e))
        .where((e) => Default.intType.fromNullable(e.qtyPicked) < e.qtyOrdered)
        .toList();
  }

  @override
  bool get isChecked => hasStarted || isChosen;

  bool get isChosen =>
      customerOrderProducts.where((e) => e.qtyPicked == 0).length ==
      customerOrderProducts.length;

/*
  @override
  Future<void> Function(bool checked) get onChecked => setPicked;
*/
  @override
  String get subtitle => displayId;

  @override
  String get title => name;

  @override
  String get trailing => qtyOrdered.toString() + "st";

/* // update single custoemr order
  @override
  Future<CustomerOrder> update() async {
    var models = await WSInteract.remoteSql(CustomerOrderQueries.single(id));

    return CustomerOrder(models.map((e) => CustomerOrderProduct(e)).toList());
  }
*/
  static CustomerOrder createEmpty() {
    return CustomerOrder([]);
  }

  bool get isEmpty => customerOrderProducts.isEmpty;
}
