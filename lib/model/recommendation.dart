import 'package:intl/intl.dart';

class Recommendation {
  String itemKey;
  String itemName;
  String price;
  String imageUrl;
  String location;
  String dateTime;

  Recommendation(this.itemKey, this.itemName, this.price, this.imageUrl,
      this.location, this.dateTime);

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    final DateFormat dateFormat = DateFormat.yMMMMd('en_US');

    return Recommendation(
      json['item_key'],
      json['item_name'],
      json['price'],
      json['image_url'],
      json['location'],
      dateFormat.format(DateTime.parse(json['date_time'])),
    );
  }
}
