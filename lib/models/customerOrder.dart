import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/utils/arg.dart';
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

  double get qtyPicked => customerOrderProducts
      .map(
          (e) => double.parse(Utils.getAndDefaultAs(e.productId, 0.toString())))
      .sum;

  bool get hasStarted =>
      customerOrderProducts
          .where((e) => Utils.defaultInt(e.qtyPicked) > 0)
          .length >=
      1;

  bool hasStartedPicking(CustomerOrderProduct c) =>
      c.qtyPicked != null && Utils.defaultInt(c.qtyPicked) > 0;

  Future<void> setPicked(bool isPicked) async {
    // signal ui before database change is completed
    CollectStore.instance.selectCustomerOrderEvent
        .broadcast(Arg(CustomerOrderSelectedEvent(this, isPicked)));

    await _setQtyPicked(isPicked);
  }

  Future<void> _setQtyPicked(bool isPicked) async {
    int? qtyPicked = isPicked ? 0 : null;

    var futures = customerOrderProducts.map((e) {
      print("id: " +
          e.productId.toString() +
          "length: " +
          customerOrderProducts.length.toString());
      return WSInteract.remoteSql(CustomerOrderQueries.setQtyPicked(
          id.toString(), e.productId.toString(), qtyPicked));
    });

    await Future.wait(futures);
  }

  static Future<List<CustomerOrder>> many() async {
    var models = await WSInteract.remoteSql(CustomerOrderQueries.many());

    return models
        .map((e) => CustomerOrderProduct(e))
        .groupListsBy((e) => e.id)
        .values
        .map((e) => CustomerOrder(e))
        .toList();
  }

  @override
  bool get isChecked => hasStarted || isChosen;

  bool get isChosen =>
      customerOrderProducts
          .where((e) => nullableIntCompare(e.qtyPicked) == 0)
          .length ==
      customerOrderProducts.length;

  int nullableIntCompare(int? i) {
    return i ?? -1;
  }

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
}
