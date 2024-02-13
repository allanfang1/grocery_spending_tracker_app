import 'dart:convert';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/goal.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
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
        Uri.parse(Constants.HOST + Constants.GET_GOALS),
        headers: {'Auth': profileRepository.user.token!});
    print("getGoals");
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      print("b");
      goals = jsonList.map((json) => Goal.fromJson(json)).toList();
      print("c");
      print(response.body);
    }
    return response;
  }

  Future<Response> createGoals(
      DateTime startDate, DateTime endDate, double budget) async {
    final response = await client.post(
        Uri.parse(Constants.HOST + Constants.CREATE_GOALS),
        headers: {'Auth': profileRepository.user.token!},
        body: jsonEncode(
            {'start_date': startDate, 'end_date': endDate, 'budget': budget}));
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }
}

@Riverpod(keepAlive: true)
GoalsRepository goalsRepository(GoalsRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return GoalsRepository(profileRepository);
}
