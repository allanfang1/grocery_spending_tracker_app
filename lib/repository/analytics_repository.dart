import 'dart:convert';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/item.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'analytics_repository.g.dart';

class AnalyticsRepository {
  AnalyticsRepository(this.profileRepository);
  final ProfileRepository profileRepository;
  http.Client client = http.Client();

  List<Transaction> transactions = [];

  Future<void> loadTransactions() async {
    final response = await client.post(
        Uri.parse(Constants.HOST + Constants.LOAD_TRANSACTIONS),
        body: {'email': profileRepository.user.email});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      transactions =
          jsonList.map((json) => Transaction.fromJson(json)).toList();
    }
  }

  List<Transaction> getTransactions() {
    return [
      Transaction(
          'transactionId',
          DateTime.now(),
          'Shopper Drug Mart',
          'description',
          [
            Item('itemId', 'productKey', DateTime.now(), 1000, 'location', true,
                'category', 'description')
          ],
          1000),
    ];
    return transactions;
  }

  Transaction getTransactionByIndex(int index) {
    return Transaction(
        'transactionId',
        DateTime.now(),
        'Shopper Drug Mart',
        'description',
        [
          Item('itemId', 'productKey', DateTime.now(), 1000, 'location', true,
              'category', 'description'),
          Item('itemId', 'productKey', DateTime.now(), 1000, 'location', true,
              'category', 'description'),
          Item('itemId', 'productKey', DateTime.now(), 1000, 'location', true,
              'category', 'description')
        ],
        1000);
    return index >= 0
        ? transactions[index]
        : Transaction.withId('No Transaction Found', []);
  }
}

@Riverpod(keepAlive: true)
AnalyticsRepository analyticsRepository(AnalyticsRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return AnalyticsRepository(profileRepository);
}
