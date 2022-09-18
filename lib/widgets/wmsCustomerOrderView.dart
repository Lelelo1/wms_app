import 'package:flutter/material.dart';
import 'package:wms_app/models/customerOrder.dart';
import 'package:wms_app/models/customerOrderProduct.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/stores/collectStore.dart';
import 'package:wms_app/utils/arg.dart';
import 'package:wms_app/utils/default.dart';
import 'package:wms_app/views/extended/stacked.dart';
import 'package:wms_app/widgets/wmsAsyncWidget.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

class WMSCustomerOrderView extends StatelessWidget {
  final CustomerOrder customerOrder;

  WMSCustomerOrderView(this.customerOrder);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(customerOrder.name,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      sizedProductViews(customerOrder.customerOrderProducts, context)
    ]);
  }

  Widget sizedProductViews(List<CustomerOrderProduct> customerOrderProducts,
          BuildContext context) =>
      Column(children: [
        ...customerOrderProducts.map((p) => Card(
            child: Container(
                child: productInformation(p),
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.85),
            margin: EdgeInsets.all(10)))
      ]);

  Widget productInformation(CustomerOrderProduct customerOrderProduct) {
    return Column(children: [
      WMSAsyncWidget<Product>(
          Product.fetchFromId(customerOrderProduct.productId),
          (product) => Column(children: [
                ProductInformationWidgets.titleArea(product.sku),
                ProductInformationWidgets.subtitleArea(
                    product.id.toString(), product.ean.toString()),
                Image.network(product.frontImage),
                ProductInformationWidgets.bottomArea(
                    product.shelf, product.qty),
                ProductInformationWidgets.nameWidget(product.name)
              ])),
      Checkbox(
          value: Default.boolType.fromInt(
              Default.intType.fromNullable(customerOrderProduct.qtyPicked)),
          onChanged: (value) async {
            await customerOrder.setQtyPicked(
                customerOrderProduct, Default.boolType.fromNullable(value));
            // just to trigger a rerender
            CollectStore.instance.selectCustomerOrderEvent.broadcast(Arg(
                CustomerOrderSelectedEvent(CustomerOrder.createEmpty(), true)));
          })
    ]);
  }
}
