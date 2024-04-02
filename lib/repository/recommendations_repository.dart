import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/recommendation.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Repository for handling user recommendations.

part 'recommendations_repository.g.dart';

class RecommendationsRepository {
  RecommendationsRepository(this.profileRepository);

  final ProfileRepository profileRepository;
  http.Client client = http.Client();

  List<Recommendation> recommendations = [];

  /* Method to fetch user recommendations based strictly on purchase history and
  * add them to the recommendations list. */
  Future<http.Response> getRecommendationsByHistory() async {
    final response = await client.get(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.RECOMMENDATIONS_PATH),
        headers: {'Auth': profileRepository.user.token!});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonList = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      for (var json in jsonList) {
        Recommendation rec = Recommendation.fromJson(json);
        if (recommendations.any((item) => rec.itemName == item.itemName)) {
          continue;
        }
        recommendations.add(Recommendation.fromJson(json));
      }
    }

    return response;
  }

  /* Method to fetch user recommendations based on low price and purchase
  * history. It adds them to the recommendations list once fetched. */
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

  // Method to return the recommendations list stored in the class.
  List<Recommendation> getRecommendations() {
    return recommendations;
  }

  // Method to clear the recommendations list on logout.
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
