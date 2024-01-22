import 'package:grocery_spending_tracker_app/src/extract_data.dart';
import 'package:grocery_spending_tracker_app/src/item.dart';
import 'package:grocery_spending_tracker_app/src/grocery_trip.dart';

class FormatReceipt {
  GroceryTrip formatGroceryTrip(List<String> receipt) {
    String userId = "filler"; // TODO
    int dateTime = ExtractData().getDateTime(receipt);
    String location = ExtractData().getLocation(receipt);
    List<Item> groceries = _formatItems(receipt);
    double subtotal = _formatPrice(ExtractData().getSubtotal(receipt));
    double total = _formatPrice(ExtractData().getTotal(receipt));

    return GroceryTrip(
        userId, dateTime, location, groceries, subtotal, total, "");
  }

  // for formatting String items into Item object
  List<Item> _formatItems(List<String> receipt) {
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

  // Should only be taking in Strings of form "(SUB)TOTAL ($)XX.XX"
  double _formatPrice(String priceLine) {
    List<String> splitPrice = priceLine.split(' ');

    return double.parse(splitPrice[1]);
  }
}