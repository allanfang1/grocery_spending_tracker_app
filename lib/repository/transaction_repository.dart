import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'transaction_repository.g.dart';

class TransactionRepository {
  TransactionRepository(this.profileRepository);
  final ProfileRepository profileRepository;
  List<Transaction> transactions = [];

  Future<void> loadTransactions() async {
    print(profileRepository.user.email);
    final response = await http.post(
        Uri(scheme: 'https', host: Constants.HOST, path: Constants.LOGIN_PATH),
        body: {'email': profileRepository.user.email});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = jsonDecode(response.body);
      transactions =
          jsonList.map((json) => Transaction.fromJson(json)).toList();
      Transaction.fromJson(response.body);
    }
  }
}

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return TransactionRepository(profileRepository);
}
