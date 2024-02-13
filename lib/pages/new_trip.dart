import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grocery_spending_tracker_app/pages/confirm_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/format_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/parse_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/extract_data.dart';
import 'package:grocery_spending_tracker_app/model/grocery_trip.dart';
import 'capture_receipt.dart';

class NewTrip extends StatefulWidget {
  const NewTrip({super.key});

  @override
  State<NewTrip> createState() => _NewTrip();
}

class _NewTrip extends State<NewTrip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("New Shopping Trip Entry"),
        // automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              SizedBox(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CaptureReceipt())
                    );
                  },
                  child: const Text('Take Photo'),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                child: OutlinedButton(
                  onPressed: _selectImage,
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final navigator = Navigator.of(context);
    final scaffold = ScaffoldMessenger.of(context);

    try {
      final receipt = await ImagePicker().pickImage(
          source: ImageSource.gallery);

      if (receipt == null) return;

      final scannedReceipt = await ParseReceipt().scanReceipt(receipt);

      final receiptToList = ExtractData().textToList(scannedReceipt);

      final GroceryTrip formattedReceipt = FormatReceipt()
          .formatGroceryTrip(receiptToList);

      await navigator.push(MaterialPageRoute(
          builder: (context) => ConfirmReceipt(tripData: formattedReceipt)));
    } catch (e) {
      scaffold.showSnackBar(const SnackBar(
        content: Text('An error occurred with the selected image.'),
      ));
    }
  }
}
