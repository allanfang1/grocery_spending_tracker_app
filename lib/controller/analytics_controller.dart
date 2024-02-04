import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:grocery_spending_tracker_app/repository/analytics_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_controller.g.dart';

@riverpod
class AnalyticsController extends _$AnalyticsController {
  @override
  FutureOr<void> build() {}

  Future<void> loadTransactions(String email, String password) async {
    return await ref.read(analyticsRepositoryProvider).loadTransactions();
  }

  List<Transaction> getTransactions() {
    return ref.read(analyticsRepositoryProvider).getTransactions();
  }
}
