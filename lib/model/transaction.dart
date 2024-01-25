import 'item.dart';

class Transaction {
  DateTime dateTime;
  String location;
  String description;
  List<Item> items;

  Transaction(this.dateTime, this.location, this.description, this.items);
}
