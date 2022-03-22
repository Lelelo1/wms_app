import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:eventsubscriber/eventsubscriber.dart';

class WMSSubscriber extends StatefulWidget {
  final Event<EventArgs> event;
  final Widget widget;
  WMSSubscriber(this.event, this.widget);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WMSSubscriber> {
  @override
  Widget build(BuildContext context) => EventSubscriber(
      event: this.widget.event, handler: (_, __) => this.widget);
}
