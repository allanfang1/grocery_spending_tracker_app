import 'dart:convert';

import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:grocery_spending_tracker_app/repository/analytics_repository.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  group("Profile Repository Tests", () {
    test("Test login call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        final mapJson = {
          'email': "a@a.com",
        };
        return Response(json.encode(mapJson), 200);
      });
      final response = await profileRepository.login("bob", "uncle");
      expect(response, 200);
      expect(profileRepository.user.email, "a@a.com");
    });

    test("Test register call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        return Response("", 200);
      });
      final response =
          await profileRepository.register("allan", "fang", "bob", "uncle");
      expect(response, 200);
    });
  });

  group("Analytics Repository Tests", () {
    late ProfileRepository profileRepository;

    setUp(() {
      profileRepository = ProfileRepository();
      profileRepository.user
          .setUser("id", "email", "token", "firstName", "lastName");
    });

    test("Test load transactions call", () async {
      final analyticsRepository = AnalyticsRepository(profileRepository);
      analyticsRepository.client = MockClient((request) async {
        final mapJson = {
          'transactionId': "100",
          'dateTime': "20010701T12:30:24",
          'location': "Fortinos 24",
          'description': '',
          'items': jsonEncode([
            {
              'itemId': "abc",
              'productKey': "abcd",
              'dateTime': "20010701T12:30:24",
              'price': 1400,
              'location': "Fortinos 24",
              'isTaxed': true,
              'category': "cheese",
              'description': ''
            },
            {
              'itemId': "xyz",
              'productKey': "wxyz",
              'dateTime': "20010701T12:30:24",
              'price': 1400,
              'location': "Fortinos 24",
              'isTaxed': true,
              'category': "cheese",
              'description': ''
            },
          ]),
        };
        return Response(json.encode([mapJson]), 200);
      });
      await analyticsRepository.loadTransactions();
      expect(analyticsRepository.transactions[0].transactionId, "100");
    });
  });
}
