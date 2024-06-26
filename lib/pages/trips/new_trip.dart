import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/pages/trips/confirm_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/format_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/parse_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/extract_data.dart';
import 'package:grocery_spending_tracker_app/model/grocery_trip.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:grocery_spending_tracker_app/pages/trips/capture_receipt.dart';

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
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text(
          Constants.NEW_TRIP,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                      'To add a grocery trip, you can take a photo of your receipt or upload a photo from your gallery.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant))),
              const SizedBox(height: 20),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceTint
                          .withOpacity(0.5),
                      elevation: 0,
                      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12)),
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const LoadingOverlay(child: CaptureReceipt()),
                        withNavBar: false);
                  },
                  child: Text(
                    'Take Photo',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceTint
                          .withOpacity(0.5),
                      elevation: 0,
                      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12)),
                  onPressed: _selectImage,
                  child: Text('Upload',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final scaffold = ScaffoldMessenger.of(context);
    final loading = LoadingOverlay.of(context);

    try {
      final receipt =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (receipt == null) return;

      loading.show();

      final scannedReceipt = await ParseReceipt().scanReceipt(receipt);

      final receiptToList = ExtractData().textToList(scannedReceipt);

      final GroceryTrip formattedReceipt =
          FormatReceipt().formatGroceryTrip(receiptToList);

      loading.hide();

      PersistentNavBarNavigator.pushNewScreen(context,
          screen:
              LoadingOverlay(child: ConfirmReceipt(tripData: formattedReceipt)),
          withNavBar: false);
    } catch (e) {
      loading.hide();
      scaffold.showSnackBar(const SnackBar(
        content: Text('An error occurred with the selected image.'),
      ));
    }
  }
}
