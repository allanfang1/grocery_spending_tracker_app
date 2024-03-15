import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/goal.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goals_repository.g.dart';

class GoalsRepository {
  GoalsRepository(this.profileRepository);
  final ProfileRepository profileRepository;
  Client client = Client();

  List<Goal> goals = [];

  Future<Response> loadGoals() async {
    final response = await client.get(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.GET_GOALS_PATH),
        headers: {'Auth': profileRepository.user.token!});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      goals = jsonList.map((json) => Goal.fromJson(json)).toList();
    }
    return response;
  }

  Future<Response> createGoal(String goalName, String goalDescription,
      String startDate, String endDate, double budget) async {
    final response = await client.post(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.CREATE_GOALS_PATH),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Auth': profileRepository.user.token!
        },
        body: jsonEncode({
          'goal_name': goalName,
          'goal_desc': goalDescription,
          'start_date': startDate,
          'end_date': endDate,
          'budget': budget
        }));
    if (response.statusCode == 200) {
      await loadGoals();
    }
    return response;
  }

  Future<Response> deleteGoal(int index) async {
    final response = await client.delete(
        Uri.parse(dotenv.env['BASE_URL']! +
            Constants.DELETE_GOALS_PATH +
            goals[index].goalId.toString()),
        headers: {'Auth': profileRepository.user.token!});
    if (response.statusCode == 200) {
      goals.removeAt(index);
    }
    return response;
  }
}

@Riverpod(keepAlive: true)
GoalsRepository goalsRepository(GoalsRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return GoalsRepository(profileRepository);
}
