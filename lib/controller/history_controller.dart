import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/history_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// This file defines the HistoryController class, responsible for managing transaction history related functionalities.

part 'history_controller.g.dart';

@riverpod
class HistoryController extends _$HistoryController {
  // Variable to store the index of the currently selected transaction.
  int transactionIndex = -1;

  // Override the build method of the parent class to load transactions asynchronously.
  @override
  Future<FutureOr<void>> build() async {
    await AsyncValue.guard(() => loadTransactions());
  }

  // Method to load transactions from the repository.
  Future<Response> loadTransactions() async {
    return await ref.read(historyRepositoryProvider).loadTransactions();
  }

  // Method to retrieve all transactions from the repository.
  List<Transaction> getTransactions() {
    return ref.read(historyRepositoryProvider).getTransactions();
  }

  // Method to delete a transaction by index from the repository.
  Future<void> deleteGoal(int index) async {
    await ref.read(historyRepositoryProvider).deleteTransaction(index);
  }

  // Method to set the transactionIndex based on the given transactionId.
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

  // Method to retrieve a transaction by its index.
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
