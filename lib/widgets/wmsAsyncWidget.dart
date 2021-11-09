import 'package:flutter/material.dart';

class WMSAsyncWidget<T> extends StatelessWidget {
  final Future<T> data;
  final Widget Function(T) render;

  WMSAsyncWidget(this.data, this.render);

  @override
  Widget build(BuildContext context) => createFutureBuilder();

  FutureBuilder createFutureBuilder() => FutureBuilder<T>(
      future: data,
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // placeolder until render with async data is finished;;
        }
        return render(snapshot.data);
      });
}
