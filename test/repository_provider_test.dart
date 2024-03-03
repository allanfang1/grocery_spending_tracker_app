import 'dart:convert';

import 'package:grocery_spending_tracker_app/repository/history_repository.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  group("Profile Repository Tests", () {
    test("Test login call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        final mapJson = {'email': "a@a.com", 'token': "yay"};
        return Response(json.encode(mapJson), 200);
      });
      final response = await profileRepository.login("bob", "uncle");
      expect(response.statusCode, 200);
      expect(profileRepository.user.email, "a@a.com");
      expect(profileRepository.user.token, "yay");
    });

    test("Test get user call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        final mapJson = {
          'email': "a@a.com",
        };
        return Response(json.encode(mapJson), 200);
      });
      profileRepository.user.token = "bob";
      final response = await profileRepository.getUser();
      expect(response.statusCode, 200);
      expect(profileRepository.user.email, "a@a.com");
    });

    test("Test register call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        return Response("", 200);
      });
      final response =
          await profileRepository.register("allan", "fang", "bob", "uncle");
      expect(response.statusCode, 200);
    });

    test("Test update user call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        return Response("", 200);
      });
      profileRepository.user.token = "bob";
      final response = await profileRepository.updateUser("allan", "fang");
      expect(response.statusCode, 200);
    });
  });

  group("Analytics Repository Tests", () {
    late ProfileRepository profileRepository;

    setUp(() {
      profileRepository = ProfileRepository();
      profileRepository.user
          .setUser(1, "email", "token", "firstName", "lastName");
    });

    test("Test load transactions call", () async {
      final analyticsRepository = HistoryRepository(profileRepository);
      analyticsRepository.client = MockClient((request) async {
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
      await analyticsRepository.loadTransactions();
      expect(analyticsRepository.transactions[0].transactionId, 2);
    });

    test("Test load transactions by id call", () async {
      final analyticsRepository = HistoryRepository(profileRepository);
      analyticsRepository.client = MockClient((request) async {
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
      await analyticsRepository.loadTransactions();
      expect(analyticsRepository.transactions[0].transactionId, 2);
    });

    test("Test get transactions by id call", () async {
      final analyticsRepository = HistoryRepository(profileRepository);
      analyticsRepository.client = MockClient((request) async {
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
      await analyticsRepository.loadTransactions();
      expect(analyticsRepository.transactions[0].transactionId, 2);
    });

    test("Test get transactions by id null call", () async {
      final analyticsRepository = HistoryRepository(profileRepository);
      analyticsRepository.client = MockClient((request) async {
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
      await analyticsRepository.loadTransactions();
      expect(analyticsRepository.getTransactionByIndex(-1), null);
    });
  });
}
