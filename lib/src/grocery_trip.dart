import 'package:grocery_spending_tracker_app/src/item.dart';

class GroceryTrip {
  String userId;
  int dateTime;
  String location;
  List<Item> items;
  double subtotal;
  double total;
  String? tripDesc;

  // create grocery trip
  GroceryTrip(this.userId, this.dateTime, this.location, this.items,
      this.subtotal, this.total, this.tripDesc);

  // update grocery trip
  updateGroceryTrip(
      int updatedDateTime,
      String updatedLocation,
      List<Item> updatedItems,
      double updatedSubtotal,
      double updatedTotal,
      String updatedTripDesc) {
    if (updatedDateTime != dateTime) dateTime = updatedDateTime;
    if (updatedLocation != location) location = updatedLocation;
    if (updatedItems != items) items = updatedItems;
    if (updatedSubtotal != subtotal) subtotal = updatedSubtotal;
    if (updatedTotal != total) total = updatedTotal;
    if (updatedTripDesc != tripDesc) tripDesc = updatedTripDesc;
  }
}