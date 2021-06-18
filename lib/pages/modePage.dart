import 'package:flutter/material.dart';
import 'package:wms_app/stores/test.dart';

class ModePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ModePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: renderContent(),
      color: Colors.grey,
    );
  }

  renderContent() {
    var list = Pages.get();

    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: list
          .map((e) => Center(
                child: Text(
                  e.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ))
          .toList(),
    );
  }
}
