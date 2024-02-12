import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:grocery_spending_tracker_app/repository/analytics_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_controller.g.dart';

@riverpod
class AnalyticsController extends _$AnalyticsController {
  int transactionIndex = -1;

  @override
  FutureOr<void> build() {}

  Future<Response> loadTransactions() async {
    return await ref.read(analyticsRepositoryProvider).loadTransactions();
  }

  List<Transaction> getTransactions() {
    return ref.read(analyticsRepositoryProvider).getTransactions();
  }

  Transaction getTransactionByIndex() {
    Transaction? transaction = ref
        .read(analyticsRepositoryProvider)
        .getTransactionByIndex(transactionIndex);
    if (transaction == null) {
      return Transaction.notFound(-1);
    } else if (transaction.subtotal == null) {
      transaction.subtotal = transaction.items!
          .fold(0, (prevVal, item) => prevVal! + (item.price ?? 0));
    }
    return transaction;
  }
}
