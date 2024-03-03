import 'dart:convert';

import 'package:grocery_spending_tracker_app/repository/goals_repository.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
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

    /*
    FRT-M9-5
    Initial State: A user is successfully logged in
    Input: n/a
    Output: List of all goals of the user
    Derivation: User requests goals
    */
    test("Test load goals", () async {
      await goalsRepository.loadGoals();
      expect(goalsRepository.goals.length, 1);
      expect(goalsRepository.goals[0].goalName, "bob");
    });

    /*
    FRT-M9-4
    Initial State: A user is successfully logged in
    Input: Goal name, description, start date, end date, budget
    Output: Success of goal creation
    Derivation: User creates a new goal
    */
    test("Test create goal", () async {
      final response = await goalsRepository.createGoal(
          "goalName", "goalDescription", "startDate", "endDate", 20.0);
      expect(response.statusCode, 200);
    });
  });
}
