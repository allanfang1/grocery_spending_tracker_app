import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/src/extract_data.dart';
import 'package:grocery_spending_tracker_app/src/item.dart';
import 'package:grocery_spending_tracker_app/src/grocery_trip.dart';

class ConfirmReceipt extends StatelessWidget {
  final List<String> receiptData;

  const ConfirmReceipt({super.key, required this.receiptData});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Scanned Receipt'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text(receiptData[0]),
        ),
      );

  // maybe have to move these to a different file to perform the
  // computations earlier

  // for formatting String items into Item object
  List<Item> formatItems(List<String> receipt) {
    List<String> parsedItems = ExtractData().getItems(receipt);
    List<Item> groceries = [];

    // Item("", "", 0.00, false)

    for (String item in parsedItems) {
      List<String> splitItem = item.split(' ');

      String itemKey = splitItem[0];
      splitItem.removeAt(0);

      double price = double.parse(splitItem.last);
      splitItem.removeLast();

      String taxIdentifier = splitItem.last;
      bool taxed = taxIdentifier.contains("H");
      splitItem.removeLast();

      String itemDesc = splitItem.join(' ');

      groceries.add(Item(itemKey, itemDesc, price, taxed));
    }

    return groceries;
  }

  GroceryTrip formatGroceryTrip(List<String> receipt, List<Item> groceries) {
    // run getters for the data and put into the below constructor

    return GroceryTrip("userId", 0, "location", [], 0, 0, "");
  }
}
