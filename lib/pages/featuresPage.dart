import 'package:flutter/material.dart';
import 'package:wms_app/features/features.dart';

class FeaturesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
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

  Widget renderFeature(Feature feature) {
    return GestureDetector(
        child: Card(
            child: Center(
          child: Text(
            feature.name,
            style: Theme.of(context).textTheme.headline5,
          ),
        )),
        onTap: () => tapFeature(feature.widget));
  }

  void tapFeature(Widget to) {
    Navigator.push(this.context, MaterialPageRoute(builder: (context) => to));
  }
}
