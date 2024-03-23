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
    await AsyncValue.guard(() => loadTransactions());
  }

  Future<Response> loadTransactions() async {
    return await ref.read(historyRepositoryProvider).loadTransactions();
  }

  List<Transaction> getTransactions() {
    return ref.read(historyRepositoryProvider).getTransactions();
  }

  Future<void> deleteGoal(int index) async {
    await ref.read(historyRepositoryProvider).deleteTransaction(index);
  }

  void setIndexById(int transactionId) {
    List<Transaction> transactions =
        ref.read(historyRepositoryProvider).getTransactions();
    for (int i = 0; i < transactions.length; i++) {
      if (transactions[i].transactionId == transactionId) {
        transactionIndex = i;
        return;
      }
    }
    transactionIndex = -1;
  }

  Transaction getTransactionByIndex() {
    print("here");
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
