import 'package:flutter/material.dart';
import 'package:wms_app/mixins/feature.dart';
import 'package:wms_app/pages/common/jobPage.dart';

// ignore: must_be_immutable
class FeaturesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
  /*
  @override
  final String name;
  */

  String name;

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
      children: [
        /*renderFeature(ProductPage("Produktinformation")),*/
        renderFeature(JobPage(
          "Standard",
        ))
      ],
    );
  }

// jobPage

  // can't provide 'JobPage' as 'AbstractPage' despite being able to do so with
  // previous pages
  Widget renderFeature(Feature feature) {
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

  void tapFeature(Widget to) async {
    Navigator.push(this.context, MaterialPageRoute(builder: (context) => to));
  }
}
