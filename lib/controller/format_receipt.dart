import 'package:grocery_spending_tracker_app/controller/extract_data.dart';
import 'package:grocery_spending_tracker_app/model/capture_item.dart';
import 'package:grocery_spending_tracker_app/model/grocery_trip.dart';

/* This file defines the FormatReceipt class, responsible for turning raw receipt data into their corresponding data types
* and formats. */

class FormatReceipt {
  /* Method uses the ExtractData class to get all the necessary information and format it all
  * into a GroceryTrip object. */
  GroceryTrip formatGroceryTrip(List<String> receipt) {
    int dateTime = ExtractData().getDateTime(receipt);
    String location = ExtractData().getLocation(receipt);
    List<Item> groceries = _formatItems(receipt);
    double subtotal = _formatPrice(ExtractData().getSubtotal(receipt));
    double total = _formatPrice(ExtractData().getTotal(receipt));

    return GroceryTrip(dateTime, location, groceries, subtotal, total, "");
  }

  // Method to format string items into Item objects.
  List<Item> _formatItems(List<String> receipt) {
    List<String> parsedItems = ExtractData().getItems(receipt);
    List<Item> groceries = [];

    for (String item in parsedItems) {
      List<String> splitItem = item.split(' ');

      String itemKey = splitItem[0];
      splitItem.removeAt(0);

      double price;
      try {
        price = double.parse(splitItem.last);
      } on FormatException {
        price = 0.00;
      }
      splitItem.removeLast();

      String taxIdentifier = splitItem.last;
      bool taxed = taxIdentifier.contains(RegExp(r'^H'));
      splitItem.removeLast();

      String itemDesc = splitItem.join(' ');

      groceries.add(Item(itemKey, itemDesc, price, taxed));
    }

    return groceries;
  }

  // Method to format string prices into doubles.
  double _formatPrice(String priceLine) {
    List<String> splitPrice = priceLine.split(' ');
    if (splitPrice[1].contains('\$')) {
      splitPrice[1] = splitPrice[1].replaceAll('\$', '');
    }

    try {
      return double.parse(splitPrice[1]);
    } on FormatException {
      return 0.00;
    }
  }
}
