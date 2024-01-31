import 'dart:convert';
import 'item.dart';

class Transaction {
  String transactionId;
  DateTime dateTime;
  String location;
  String description;
  List<Item> items;

  Transaction(this.transactionId, this.dateTime, this.location,
      this.description, this.items);

  factory Transaction.fromJson(dynamic json) {
    List<Map<String, dynamic>> jsonItems = jsonDecode(json['items']);
    List<Item> items = jsonItems.map((json) => Item.fromJson(json)).toList();

    return Transaction(
        json['transactionId'] as String,
        DateTime.parse(json['dateTime']),
        json['location'] as String,
        json['description'] as String,
        items);
  }
}
