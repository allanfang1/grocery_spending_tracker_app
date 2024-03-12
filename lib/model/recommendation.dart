class Recommendation {
  String itemKey;
  String itemName;
  String price;
  String imageUrl;
  String location;
  String dateTime;
  String frequency;

  Recommendation(this.itemKey, this.itemName, this.price, this.imageUrl,
      this.location, this.dateTime, this.frequency);

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      json['item_key'],
      json['item_name'],
      json['price'],
      json['image_url'],
      json['location'],
      json['date_time'],
      json['frequency']
    );
  }

}
