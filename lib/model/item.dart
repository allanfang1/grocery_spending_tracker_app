/// Represents a grocery item.
class Item {
  int? itemId;
  String? productKey;
  double? price;
  String? location;
  bool? isTaxed;
  String? category;
  String? description;

  /// Constructor for creating an Item object.
  Item(this.itemId, this.productKey, this.price, this.location, this.isTaxed,
      this.category, this.description);

  /// Factory method to create an Item object from JSON data.
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
