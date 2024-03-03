import 'dart:convert';

import 'package:grocery_spending_tracker_app/repository/goals_repository.dart';
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

  group("Goals Repository Tests", () {
    late ProfileRepository profileRepository;
    late GoalsRepository goalsRepository;

    setUp(() {
      profileRepository = ProfileRepository();
      profileRepository.user
          .setUser(1, "email", "token", "firstName", "lastName");
      goalsRepository = GoalsRepository(profileRepository);
      goalsRepository.client = MockClient((request) async {
        final mapJson = [
          {
            'goal_name': "bob",
            'goal_desc': "yes",
            'start_date': "20010701T12:30:24",
            'end_date': "20010701T12:30:24",
            'budget': "100.00",
          }
        ];
        return Response(json.encode(mapJson), 200);
      });
    });

    test("Test get goals", () async {
      await goalsRepository.getGoals();
      expect(goalsRepository.goals.length, 1);
      expect(goalsRepository.goals[0].goalName, "bob");
    });

    test("Test get transactions by id call", () async {
      final response = await goalsRepository.createGoal(
          "goalName", "goalDescription", "startDate", "endDate", 20.0);
      expect(response.statusCode, 200);
    });
  });

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

    test("Test load transactions call", () async {
      await historyRepository.loadTransactions();
      expect(historyRepository.transactions[0].transactionId, 2);
    });

    test("Test get transactions by id call", () async {
      await historyRepository.loadTransactions();
      expect(historyRepository.transactions[0].transactionId, 2);
    });

    test("Test get transactions by id null call", () async {
      await historyRepository.loadTransactions();
      expect(historyRepository.getTransactionByIndex(-1), null);
    });
  });
}
