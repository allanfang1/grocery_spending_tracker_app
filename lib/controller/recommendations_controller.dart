import 'package:grocery_spending_tracker_app/model/recommendation.dart';
import 'package:grocery_spending_tracker_app/repository/recommendations_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// This file defines the RecommendationsController, responsible for fetching item recommendations for users.

part 'recommendations_controller.g.dart';

@riverpod
class RecommendationsController extends _$RecommendationsController {
  // Override the build class of the parent such that recommendations are fetched on build.
  @override
  Future<FutureOr<void>> build() async {
    await AsyncValue.guard(() => getRecommendationsByPrice());
    await AsyncValue.guard(() => getRecommendationsByHistory());
  }

  // Method to get similar item recommendations based on purchase history.
  Future<Response> getRecommendationsByHistory() async {
    return await ref
        .read(recommendationsRepositoryProvider)
        .getRecommendationsByHistory();
  }

  // Method to get recommendations based on low prices compared to prices of items in purchase history.
  Future<Response> getRecommendationsByPrice() async {
    return await ref
        .read(recommendationsRepositoryProvider)
        .getRecommendationsByPrice();
  }

  // Method to return the recommendations list stored in the class.
  List<Recommendation> getRecommendations() {
    return ref.read(recommendationsRepositoryProvider).getRecommendations();
  }

  // Method to clear recommendations on user logout.
  void logout() {
    return ref.read(recommendationsRepositoryProvider).logout();
  }
}
