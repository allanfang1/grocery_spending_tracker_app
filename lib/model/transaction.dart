import 'item.dart';

class Transaction {
  late int transactionId;
  DateTime? dateTime;
  String? location;
  String? description;
  List<Item>? items;
  double? subtotal;
  late double total;

  Transaction(this.transactionId, this.dateTime, this.location,
      this.description, this.items, this.subtotal, this.total);

  Transaction.notFound(int transactionId) {
    this.transactionId = transactionId;
    total = 0;
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    List<Item> items;
    if (json['items'] == null) {
      items = [];
    } else {
      items = (json['items'] as List)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return Transaction(
      json['trip_id'] as int,
      json['date_time'] != null ? DateTime.parse(json['date_time']) : null,
      json['location'] as String?,
      json['description'] as String?,
      items,
      double.tryParse(json['subtotal']),
      double.tryParse(json['total']) ?? 0,
    );
  }
}
