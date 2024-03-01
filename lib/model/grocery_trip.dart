import 'package:grocery_spending_tracker_app/model/capture_item.dart';
import 'package:intl/intl.dart';

class GroceryTrip {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  int dateTime;
  String location;
  List<Item> items;
  double subtotal;
  double total;
  String? tripDesc;

  // create grocery trip
  GroceryTrip(this.dateTime, this.location, this.items, this.subtotal,
      this.total, this.tripDesc);

  // update grocery trip
  updateGroceryTrip(
      int? updatedDateTime,
      String? updatedLocation,
      List<Item>? updatedItems,
      double? updatedSubtotal,
      double? updatedTotal,
      String? updatedTripDesc) {
    if (updatedDateTime != null && updatedDateTime != dateTime) {
      dateTime = updatedDateTime;
    }
    if (updatedLocation != null && updatedLocation != location) {
      location = updatedLocation;
    }
    if (updatedItems != null && updatedItems != items) items = updatedItems;
    if (updatedSubtotal != null && updatedSubtotal != subtotal) {
      subtotal = updatedSubtotal;
    }
    if (updatedTotal != null && updatedTotal != total) total = updatedTotal;
    if (updatedTripDesc != null && updatedTripDesc != tripDesc) {
      tripDesc = updatedTripDesc;
    }
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemList = [];

    for (Item item in items) {
      itemList.add(item.toJson());
    }

    return {
      'date_time': _dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(dateTime * 1000)),
      'location': location,
      'items': itemList,
      'subtotal': subtotal,
      'total': total,
      'trip_desc': tripDesc
    };
  }
}
