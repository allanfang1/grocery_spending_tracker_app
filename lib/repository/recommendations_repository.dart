import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/recommendation.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendations_repository.g.dart';

class RecommendationsRepository {
  RecommendationsRepository(this.profileRepository);

  final ProfileRepository profileRepository;
  http.Client client = http.Client();

  List<Recommendation> recommendations = [];

  Future<http.Response> getRecommendationsByHistory() async {
    final response = await client.get(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.RECOMMENDATIONS_PATH),
        headers: {'Auth': profileRepository.user.token!});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      for (var json in jsonList) {
        recommendations.add(Recommendation.fromJson(json));
      }
    }

    return response;
  }

  Future<http.Response> getRecommendationsByPrice() async {
    final response = await client.get(
        Uri.parse(
            dotenv.env['BASE_URL']! + Constants.RECOMMENDATIONS_LOWEST_PATH),
        headers: {'Auth': profileRepository.user.token!});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      for (var json in jsonList) {
        recommendations.add(Recommendation.fromJson(json));
      }
    }

    return response;
  }

  List<Recommendation> getRecommendations() {
    return recommendations;
  }

  void logout() {
    recommendations = [];
  }
}

@Riverpod(keepAlive: true)
RecommendationsRepository recommendationsRepository(
    RecommendationsRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return RecommendationsRepository(profileRepository);
}
