import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/utils.dart';
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
  List<String> get productId =>
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
    if (hasStarted) {
      return;
    }

    print("set qtyPicked: " + isPicked.toString());

    await _setQtyPicked(isPicked);
  }

  Future<void> _setQtyPicked(bool isPicked) async {
    int? qtyPicked = isPicked ? 0 : null;

/*
    // can't set qtyPicked in db to null
    if (qtyPicked == null) {
      print("seeeet 10 !!");
      qtyPicked = 10;
    }
*/
    var futures = customerOrderProducts.map((e) => WSInteract.remoteSql(
        CustomerOrderQueries.setQtyPicked(
            id.toString(), e.productId, qtyPicked)));

    await Future.wait(futures);
  }

  Future<CustomerOrder> single() async {
    var model = await WSInteract.remoteSql(CustomerOrderQueries.single(id));
    if (model.isEmpty) {
      return CustomerOrder([]);
    }
    return CustomerOrder([CustomerOrderProduct(model.first)]);
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
  // TODO: implement isChecked
  bool get isChecked => hasStarted || isChosen;

  bool get isChosen =>
      customerOrderProducts
          .where((e) => nullableIntCompare(e.qtyPicked) == 0)
          .length ==
      customerOrderProducts.length;

  int nullableIntCompare(int? i) {
    return i ?? -1;
  }

  @override
  // TODO: implement onChecked
  Future<void> Function(bool checked) get onChecked => setPicked;

  @override
  // TODO: implement subtitle
  String get subtitle => displayId;

  @override
  // TODO: implement title
  String get title => name;

  @override
  // TODO: implement trailing
  String get trailing => qtyOrdered.toString() + "st";

  @override
  // TODO: implement update
  Future<WMSCardCheckerProps> Function() get update => single;
}
