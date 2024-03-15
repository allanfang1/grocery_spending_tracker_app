class Item {
  int? itemId;
  String? productKey;
  double? price;
  String? location;
  bool? isTaxed;
  String? category;
  String? description;

  Item(this.itemId, this.productKey, this.price, this.location, this.isTaxed,
      this.category, this.description);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['item_id'] as int?,
      json['item_key'] as String?,
      double.tryParse(json['price']),
      json['location'] as String?,
      json['taxed'] as bool?,
      json['category'] as String?,
      json['item_desc'] as String?,
    );
  }
}
