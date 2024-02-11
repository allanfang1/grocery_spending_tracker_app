import 'dart:convert';
import 'item.dart';

class Transaction {
  String transactionId;
  DateTime? dateTime;
  String? location;
  String? description;
  List<Item> items;
  int? total;

  Transaction(this.transactionId, this.dateTime, this.location,
      this.description, this.items, this.total);

  Transaction.withId(this.transactionId, this.items);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    List<Item> items = (jsonDecode(json['items']) as List)
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList();
    return Transaction(
        json['transactionId'] as String,
        DateTime.parse(json['dateTime']),
        json['location'] as String,
        json['description'] as String,
        items,
        json['total'] as int);
  }
}
