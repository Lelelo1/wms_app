class CustomerOrder {
  Map<String, dynamic> _attributes;
  CustomerOrder(this._attributes);

  int id get => _attributes["entity_id"];
}
