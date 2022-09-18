import 'package:event/event.dart';
import 'package:wms_app/models/customerOrder.dart';

class Arg<T> extends EventArgs {
  T _t;
  T get t => _t;
  Arg(this._t);
}

// events/commands with models..

class CustomerOrderSelectedEvent {
  CustomerOrder _customerOrder;
  CustomerOrder get customerOrder => _customerOrder;
  bool _selected;
  bool get selected => _selected;

  CustomerOrderSelectedEvent(this._customerOrder, this._selected);
}
