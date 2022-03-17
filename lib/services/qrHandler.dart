class QRHandler {
  static final String shelfPrefix = "shelf:";

  static bool _isShelf(String scanData) {
    return scanData.contains(shelfPrefix);
  }

  static void handle(String scanData) {
    if (!_isShelf(scanData)) {
      return;
    }
  }
}
