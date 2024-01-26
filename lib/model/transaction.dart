import 'item.dart';

class Transaction {
  String transactionId;
  DateTime dateTime;
  String location;
  String description;
  List<Item> items;

  Transaction(this.transactionId, this.dateTime, this.location,
      this.description, this.items);
}
