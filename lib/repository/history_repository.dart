import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'history_repository.g.dart';

// Repository class for managing transaction history.
class HistoryRepository {
  HistoryRepository(this.profileRepository);
  final ProfileRepository profileRepository;
  http.Client client = http.Client();

  List<Transaction> transactions = [];

  // Method to load user transactions from the server.
  Future<Response> loadTransactions() async {
    final response = await client.get(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.LOAD_TRANSACTIONS_PATH),
        headers: {'Auth': profileRepository.user.token!});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      transactions =
          jsonList.map((json) => Transaction.fromJson(json)).toList();
    }
    return response;
  }

  // Method to delete a transaction from the server.
  Future<Response> deleteTransaction(int index) async {
    final response = await client.delete(
        Uri.parse(dotenv.env['BASE_URL']! +
            Constants.DELETE_TRANSACTION_PATH +
            transactions[index].transactionId.toString()),
        headers: {'Auth': profileRepository.user.token!});
    if (response.statusCode == 200) {
      transactions.removeAt(index);
    }
    return response;
  }

  // Getter to get all transactions.
  List<Transaction> getTransactions() {
    return transactions;
  }

  // Method to get transaction by index.
  Transaction? getTransactionByIndex(int index) {
    return (index < 0 || index >= transactions.length)
        ? null
        : transactions[index];
  }
}

@Riverpod(keepAlive: true)
HistoryRepository historyRepository(HistoryRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return HistoryRepository(profileRepository);
}
