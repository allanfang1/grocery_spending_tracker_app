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

  List<Item> formatItems(List<String> receipt) {
    List<String> parsedItems = ExtractData().getItems(receipt);
    List<Item> groceries = [];

    // Item("", "", 0.00, false)

    // first word is gonna be the SKU
    // next n number of words are description
    // HMRJ or MRJ for tax
    // final word would be the price

    return groceries;
  }

  GroceryTrip formatGroceryTrip(List<String> receipt, List<Item> groceries) {
    // run getters for the data and put into the below constructor

    return GroceryTrip("userId", 0, "location", [], 0, 0, "");
  }
}
