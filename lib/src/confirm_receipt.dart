import 'package:flutter/material.dart';
import 'grocery_trip.dart';

class ConfirmReceipt extends StatefulWidget {
  final GroceryTrip tripData;

  const ConfirmReceipt({ Key? key, required this.tripData}): super(key: key);

  @override
  State<ConfirmReceipt> createState() => _ConfirmReceiptState();
}

class _ConfirmReceiptState extends State<ConfirmReceipt> {
  // create late variables here

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // set variables to widget.tripData values here
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

  // maybe have to move these to a different file to perform the
  // computations earlier


}
