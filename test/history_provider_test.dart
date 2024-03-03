import 'dart:convert';

import 'package:grocery_spending_tracker_app/repository/history_repository.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  group("History Repository Tests", () {
    late ProfileRepository profileRepository;
    late HistoryRepository historyRepository;

    setUp(() {
      profileRepository = ProfileRepository();
      profileRepository.user
          .setUser(1, "email", "token", "firstName", "lastName");
      historyRepository = HistoryRepository(profileRepository);
      historyRepository.client = MockClient((request) async {
        final mapJson = [
          {
            'trip_id': 2,
            'date_time': "20010701T12:30:24",
            'location': "Fortinos 24",
            'description': '',
            'subtotal': "100.00",
            'total': '100.00',
            'items': [
              {
                'item_id': 1,
                'item_key': "abcd",
                'dateTime': "20010701T12:30:24",
                'price': "1400.00",
                'location': "Fortinos 24",
                'isTaxed': true,
                'category': "cheese",
                'description': ''
              },
              {
                'item_id': 3,
                'item_key': "wxyz",
                'dateTime': "20010701T12:30:24",
                'price': "1400.00",
                'location': "Fortinos 24",
                'isTaxed': true,
                'category': "cheese",
                'description': ''
              },
            ],
          }
        ];
        return Response(json.encode(mapJson), 200);
      });
    });

    /*
    FRT-M9-1
    Initial State: A user is successfully logged in
    Input: n/a
    Output: List of all transactions of the user ordered by recency 
    Derivation: User requests transaction history
    */
    test("Test load transactions call", () async {
      await historyRepository.loadTransactions();
      expect(historyRepository.transactions[0].transactionId, 2);
    });

    /*
    FRT-M9-2
    Initial State: A user is successfully logged in
    Input: Index number
    Output: Transaction instance
    Derivation: User accessing a single transaction instance
    */
    test("Test get transactions by id call", () async {
      await historyRepository.loadTransactions();
      expect(historyRepository.getTransactionByIndex(0)?.transactionId, 2);
    });

    /*
    FRT-M9-3
    Initial State: A user is successfully logged in
    Input: Index number
    Output: null
    Derivation: User accessing a single transaction instance with an invalid index
    */
    test("Test get transactions by id null call", () async {
      await historyRepository.loadTransactions();
      expect(historyRepository.getTransactionByIndex(-1), null);
    });
  });
}
