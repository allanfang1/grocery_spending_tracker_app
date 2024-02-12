import 'dart:convert';
import 'package:grocery_spending_tracker_app/model/grocery_trip.dart';
import 'package:grocery_spending_tracker_app/repository/confirm_receipt_repository.dart';

class ConfirmReceiptController {
  Future<int> submitTrip(GroceryTrip trip) async {
    int userId = 6; // TODO temp hardcoded, get from login
    String jsonTrip = jsonEncode(trip);
    return await ConfirmReceiptRepository().submitTrip(userId, jsonTrip);
  }
}