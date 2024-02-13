import 'dart:convert';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/item.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'history_repository.g.dart';

class HistoryRepository {
  HistoryRepository(this.profileRepository);
  final ProfileRepository profileRepository;
  http.Client client = http.Client();

  List<Transaction> transactions = [];

  Future<Response> loadTransactions() async {
    final response = await client.get(
        Uri.parse(Constants.HOST + Constants.LOAD_TRANSACTIONS),
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

  List<Transaction> getTransactions() {
    return transactions;
  }

  Transaction? getTransactionByIndex(int index) {
    return index >= 0 ? transactions[index] : null;
  }
}

@Riverpod(keepAlive: true)
HistoryRepository historyRepository(HistoryRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return HistoryRepository(profileRepository);
}
