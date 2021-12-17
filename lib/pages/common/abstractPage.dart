import 'package:flutter/material.dart';
import 'package:wms_app/jobs/identify.dart';
import 'package:wms_app/models/product.dart';
import 'package:wms_app/pages/common/searchPage.dart';
import 'package:wms_app/routes/productRoute.dart';
import 'package:wms_app/routes/searchRoute.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/utils.dart';
import 'package:wms_app/widgets/wmsEmptyWidget.dart';

typedef ContentFunc = Widget Function([Product p, String ean]);

class AbstractPage {
  final workStore = WorkStore.instance;

  //Job get job;
  String name = "";

  //AbstractPage(this.name);

  ContentFunc imageContent = (
          [Product p = const Product.empty(), String ean = ""]) =>
      WMSEmptyWidget();

  ContentFunc fadeContent = (
          [Product p = const Product.empty(), String ean = ""]) =>
      p.exists() ? WMSEmptyWidget() : SearchRoute(SearchPage(ean));

  ContentFunc scrollContent = (
          [Product p = const Product.empty(), String ean = ""]) =>
      p.exists() ? ProductRoute(p) : WMSEmptyWidget();
}
