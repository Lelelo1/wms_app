import 'package:wms_app/models/collectRoute.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/stores/workStore.dart';

class CollectStore {
  static late CollectStore instance = CollectStore._();
  CollectStore._();

  List<CustomerOrder> chosenCustomerOrders = [];

  CustomerOrderProduct currentCustomerOrderProduct =
      CustomerOrderProduct.empty();

  static WorkStore workStore = WorkStore.instance;

  void setCollect(CollectRoute collectRoute) async {
    if(customerOrder == )
    workStore.clearAll();
  }

  void setCurrentProduct(CustomerOrderProduct customerOrderProduct) async {
    WorkStore.instance.currentProduct =
        await Product.fetchFromId(currentCustomerOrderProduct.id.toString());
  }
}
