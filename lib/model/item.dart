import 'dart:ffi';

class Item {
  String productKey;
  DateTime dateTime;
  int price;
  String location;
  Bool isTaxed;
  String category;

  Item(this.productKey, this.dateTime, this.price, this.location, this.isTaxed,
      this.category);
}
