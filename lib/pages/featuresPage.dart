import 'package:flutter/material.dart';
import 'package:wms_app/features/features.dart';
import 'package:wms_app/pages/AbstractPage.dart';

class FeaturesPage extends StatefulWidget implements AbstractPage {
  @override
  State<StatefulWidget> createState() => _State();

  @override
  final String name;

  FeaturesPage(this.name);
}

class _State extends State<FeaturesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: renderContent(),
      color: Colors.grey,
    );
  }

  renderContent() {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: Features.get().map(renderFeature).toList(),
    );
  }

  Widget renderFeature(AbstractPage feature) {
    return GestureDetector(
        child: Card(
            child: Center(
          child: Text(
            feature.name,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        )),
        onTap: () => tapFeature(feature as Widget));
  }

  void tapFeature(Widget to) {
    Navigator.push(this.context, MaterialPageRoute(builder: (context) => to));
  }
}
