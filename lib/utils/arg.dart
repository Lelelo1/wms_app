import 'package:event/event.dart';

class Arg<T> extends EventArgs {
  T _t;
  T get t => _t;
  Arg(this._t);
}
