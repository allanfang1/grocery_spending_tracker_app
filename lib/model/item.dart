class Item {
  String itemId;
  String productKey;
  DateTime dateTime;
  int price;
  String location;
  bool isTaxed;
  String category;
  String description;

  Item(this.itemId, this.productKey, this.dateTime, this.price, this.location,
      this.isTaxed, this.category, this.description);

  factory Item.fromJson(dynamic json) {
    return Item(
      json['itemId'] as String,
      json['productKey'] as String,
      DateTime.parse(json['dateTime']),
      json['price'] as int,
      json['location'] as String,
      json['isTaxed'] as bool,
      json['category'] as String,
      json['description'] as String,
    );
  }
}
