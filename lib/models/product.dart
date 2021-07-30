class Product {
  // String image; // thumbnai with zoom
  // in order of importance, potentially break into different class when need, andmore features are developed

  // ean and sku are varchar (strings) in database, but can't and should really not contain letters I think?

  String ean;
  String sku; // artikelnummer
  String shelf; // hyllplats
  String name; // namn
  String image; // image
  int box; // låda, does not exist in databse is created

  Product(String ean, String sku, String shelf, String name,
      [String image, int box]) {
    this.ean = ean;
    this.sku = sku;
    this.shelf = shelf;
    this.name = name;
    this.image = image;
    this.box = box;
  }

// calling 'toString()' is needed, even for the the already Sring fields

  @override
  String toString() {
    return "ean: " +
        ean.toString() +
        ", sku: " +
        sku.toString() +
        ", shelf: " +
        shelf.toString() +
        ", name: " +
        name.toString() +
        ", image: " +
        image.toString();
  }

  // (box)
}
