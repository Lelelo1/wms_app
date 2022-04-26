class Mappings {
  Map<String, String> map = {"": "", "": ""};
}

class Mapping {
  Subject fetchProductSubject = Subject(
      [Attribute("entity_id", ""), Attribute("attribute_id", "283")],
      ["catalog_product_entity", "catalog_product_entity_varchar"]);

  static String sql(Subject s, String Function() build) => build();
}

class Subject {
  List<Attribute> attributes = [];
  List<String> tables = [];
  Subject(this.attributes, this.tables);

  String sql(String Function(Subject s) sql) => sql(this);
}

class Attribute {
  String name;
  String value;

  Attribute(this.name, this.value);
}
