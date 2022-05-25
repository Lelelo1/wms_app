abstract class WMSProps<T> {
  abstract Future<T> Function() update;
}
