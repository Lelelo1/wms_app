class AutoGenerate {
  AutoGenerate({
    required this.commentScanning,
    required this.getProduct,
    required this.productSuggestions,
    required this.findShelf,
    required this.increaseQuantity,
    required this.commentProductAttributes,
    required this.getEAN,
    required this.getName,
    required this.getShelf,
    required this.getSKU,
    required this.getImages,
    required this.getQuantity,
    required this.setEAN,
  });
  late final List<String> commentScanning;
  late final List<String> getProduct;
  late final List<String> productSuggestions;
  late final List<String> findShelf;
  late final List<String> increaseQuantity;
  late final String commentProductAttributes;
  late final List<String> getEAN;
  late final List<String> getName;
  late final List<String> getShelf;
  late final List<String> getSKU;
  late final List<String> getImages;
  late final List<String> getQuantity;
  late final List<String> setEAN;

  AutoGenerate.fromJson(Map<String, dynamic> json) {
    commentScanning = List.castFrom<dynamic, String>(json['commentScanning']);
    getProduct = List.castFrom<dynamic, String>(json['getProduct']);
    productSuggestions =
        List.castFrom<dynamic, String>(json['productSuggestions']);
    findShelf = List.castFrom<dynamic, String>(json['findShelf']);
    increaseQuantity = List.castFrom<dynamic, String>(json['increaseQuantity']);
    commentProductAttributes = json['commentProductAttributes'];
    getEAN = List.castFrom<dynamic, String>(json['getEAN']);
    getName = List.castFrom<dynamic, String>(json['getName']);
    getShelf = List.castFrom<dynamic, String>(json['getShelf']);
    getSKU = List.castFrom<dynamic, String>(json['getSKU']);
    getImages = List.castFrom<dynamic, String>(json['getImages']);
    getQuantity = List.castFrom<dynamic, String>(json['getQuantity']);
    setEAN = List.castFrom<dynamic, String>(json['setEAN']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['commentScanning'] = commentScanning;
    _data['getProduct'] = getProduct;
    _data['productSuggestions'] = productSuggestions;
    _data['findShelf'] = findShelf;
    _data['increaseQuantity'] = increaseQuantity;
    _data['commentProductAttributes'] = commentProductAttributes;
    _data['getEAN'] = getEAN;
    _data['getName'] = getName;
    _data['getShelf'] = getShelf;
    _data['getSKU'] = getSKU;
    _data['getImages'] = getImages;
    _data['getQuantity'] = getQuantity;
    _data['setEAN'] = setEAN;
    return _data;
  }
}
