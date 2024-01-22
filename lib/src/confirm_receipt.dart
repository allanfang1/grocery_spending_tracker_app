import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/src/grocery_trip.dart';
import 'package:grocery_spending_tracker_app/src/item.dart';

class ConfirmReceipt extends StatefulWidget {
  final GroceryTrip tripData;

  const ConfirmReceipt({ Key? key, required this.tripData}): super(key: key);

  @override
  State<ConfirmReceipt> createState() => _ConfirmReceiptState();
}

class _ConfirmReceiptState extends State<ConfirmReceipt> {
  late int dateTime;
  late String location;
  late List<Item> items;
  late double subtotal;
  late double total;
  late String? tripDesc;

  @override
  void initState() {
    super.initState();

    dateTime = widget.tripData.dateTime;
    location = widget.tripData.location;
    items = widget.tripData.items;
    subtotal = widget.tripData.subtotal;
    total = widget.tripData.total;
    tripDesc = widget.tripData.tripDesc;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Scanned Receipt'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text("Hello"),
        ),
      );
}
