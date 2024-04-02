import 'package:grocery_spending_tracker_app/repository/goals_repository.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// This file defines the GoalsController class, responsible for managing goals related functionalities.

part 'goals_controller.g.dart';

@riverpod
class GoalsController extends _$GoalsController {
  @override
  Future<FutureOr<void>> build() async {}

  // Method to create a new goal.
  Future<Response> createGoal(String goalName, String goalDescription,
      DateTime startDate, DateTime endDate, String budget) async {
    return await ref.read(goalsRepositoryProvider).createGoal(
        goalName,
        goalDescription,
        DateFormat('yyyy-MM-dd').format(startDate),
        DateFormat('yyyy-MM-dd').format(endDate),
        double.parse(budget));
  }
}
