class Recommendation {
  String itemKey;
  String itemName;
  String price;
  String imageUrl;
  String location;
  DateTime dateTime;

  Recommendation(this.itemKey, this.itemName, this.price, this.imageUrl,
      this.location, this.dateTime);

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      json['item_key'],
      json['item_name'],
      json['price'],
      json['image_url'],
      json['location'],
      DateTime.parse(json['date_time']),
    );
  }
}
