import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/history_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_controller.g.dart';

@riverpod
class HistoryController extends _$HistoryController {
  int transactionIndex = -1;

  @override
  Future<FutureOr<void>> build() async {
    state = await AsyncValue.guard(() => loadTransactions());
  }

  Future<Response> loadTransactions() async {
    return await ref.read(historyRepositoryProvider).loadTransactions();
  }

  List<Transaction> getTransactions() {
    return ref.read(historyRepositoryProvider).getTransactions();
  }

  Transaction getTransactionByIndex() {
    Transaction? transaction = ref
        .read(historyRepositoryProvider)
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
