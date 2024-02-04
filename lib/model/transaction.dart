import 'dart:convert';
import 'item.dart';

class Transaction {
  String transactionId;
  DateTime? dateTime;
  String location;
  String description;
  List<Item> items;

  Transaction(this.transactionId, this.dateTime, this.location,
      this.description, this.items);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    List<Item> items = (jsonDecode(json['items']) as List)
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList();
    // List<Map<String, dynamic>> jsonItems = (jsonDecode(json['items']) as List)
    //     .map((e) => e as Map<String, dynamic>)
    //     .toList();
    // List<Item> items = jsonItems.map((json) => Item.fromJson(json)).toList();
    return Transaction(
        json['transactionId'] as String,
        DateTime.parse(json['dateTime']),
        json['location'] as String,
        json['description'] as String,
        items);
  }
}
