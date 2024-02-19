import 'dart:convert';
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

  Future<Response> getGoals() async {
    final response = await client.get(
        Uri.parse(Constants.HOST + Constants.GET_GOALS_PATH),
        headers: {'Auth': profileRepository.user.token!});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      goals = jsonList.map((json) => Goal.fromJson(json)).toList();
    }
    return response;
  }

  Future<Response> createGoal(
      String startDate, String endDate, double budget) async {
    final response = await client.post(
        Uri.parse(Constants.HOST + Constants.CREATE_GOALS_PATH),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Auth': profileRepository.user.token!
        },
        body: jsonEncode(
            {'start_date': startDate, 'end_date': endDate, 'budget': budget}));
    if (response.statusCode == 200) {
      print(response.body);
      await getGoals();
    }
    return response;
  }
}

@Riverpod(keepAlive: true)
GoalsRepository goalsRepository(GoalsRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return GoalsRepository(profileRepository);
}
