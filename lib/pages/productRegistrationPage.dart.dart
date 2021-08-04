import 'package:flutter/material.dart';
import 'package:wms_app/models/sequence.dart';
import 'package:wms_app/pages/abstractPage.dart';
import 'package:wms_app/pages/loadingPage.dart';
import 'package:wms_app/stores/appStore.dart';
import 'package:wms_app/stores/workStore.dart';
import 'package:wms_app/views/cameraView.dart';
import 'package:wms_app/views/productView.dart';
import 'package:wms_app/widgets/WmsAppBar.dart';

class ProductRegistrationPage extends StatefulWidget implements AbstractPage {
  @override
  State<StatefulWidget> createState() => _State();

  @override
  final String name;

  ProductRegistrationPage(this.name);
}

class _State extends State<ProductRegistrationPage> {
  WorkStore workStore = AppStore.injector.get<WorkStore>();

  Future<Sequence> futureSequence;

  @override
  void initState() {
    super.initState();
    futureSequence = workStore.getCollection(); // later call 'getRegistration'
  }

  FutureBuilder futureBuilder() => FutureBuilder<Sequence>(
      future: futureSequence,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        }
        return page(snapshot.data);
      });

  Widget page(Sequence sequence) {
    return Scaffold(
        appBar: WMSAppBar(this.widget.name).get(),
        body: Container(
            child: (Column(children: [
          Expanded(child: CameraView() /*top()*/),
          Expanded(child: ProductView(sequence.iterator.current))
        ]))),
        extendBodyBehindAppBar: true);
  }

  @override
  Widget build(BuildContext context) {
    return futureBuilder();
  }
}
