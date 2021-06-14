
class Product {
  // String image; // thumbnai with zoom
  String name; // namn
  String shelf; // hyllplats
  int number; // artikelnummer
  int box; // boxnummer
  
  Product(String name, String shelf, int number, int box) {
    this.name = name;
    this.shelf = shelf;
    this.number = number;
    this.box = box;
  }
}