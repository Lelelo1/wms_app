// having objects tied directly to warehousesystem/database

class Product {
  int id;
  Product(int id);
  String getEAN() {}
  String getSKU() {}
  String getShelf() {}
  Future<String> getName() {}
  String getImage() {}
}
