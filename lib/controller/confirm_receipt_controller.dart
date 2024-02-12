import 'dart:convert';
import 'package:grocery_spending_tracker_app/model/grocery_trip.dart';
import 'package:grocery_spending_tracker_app/repository/confirm_receipt_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'confirm_receipt_controller.g.dart';

@riverpod
class ConfirmReceiptController extends _$ConfirmReceiptController {
  @override
  FutureOr<void> build() {}

  Future<int> submitTrip(GroceryTrip trip) async {
    String jsonTrip = jsonEncode(trip);
    return await ref.read(confirmReceiptRepositoryProvider).submitTrip(jsonTrip);
  }
}