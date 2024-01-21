import 'package:flutter/material.dart';

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
}