import 'item.dart';

/// Represents a transaction in the application.
class Transaction {
  late int transactionId;
  late DateTime dateTime;
  String? location;
  String? description;
  late List<Item> items;
  double? subtotal;
  late double total;

  /// Constructor for creating a Transaction object.
  Transaction(this.transactionId, this.dateTime, this.location,
      this.description, this.items, this.subtotal, this.total);

  /// Constructor for creating a blank Transaction object when the transaction is not found.
  Transaction.notFound(int transactionId) {
    this.transactionId = transactionId;
    total = 0;
    dateTime = DateTime.utc(1, 1, 1);
    items = [];
  }

  /// Factory method to create a Transaction object from JSON data.
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
      json['date_time'] != null
          ? DateTime.tryParse(json['date_time']) ?? DateTime.utc(1, 1, 1)
          : DateTime.utc(1, 1, 1),
      json['location'] as String?,
      json['description'] as String?,
      items,
      double.tryParse(json['subtotal']),
      double.tryParse(json['total']) ?? 0,
    );
  }
}
