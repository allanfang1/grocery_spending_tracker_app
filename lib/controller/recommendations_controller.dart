import 'package:grocery_spending_tracker_app/model/recommendation.dart';
import 'package:grocery_spending_tracker_app/repository/recommendations_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendations_controller.g.dart';

@riverpod
class RecommendationsController extends _$RecommendationsController {
  @override
  Future<FutureOr<void>> build() async {
    await AsyncValue.guard(() => getRecommendationsByPrice());
    await AsyncValue.guard(() => getRecommendationsByHistory());
  }

  Future<Response> getRecommendationsByHistory() async {
    return await ref
        .read(recommendationsRepositoryProvider)
        .getRecommendationsByHistory();
  }

  Future<Response> getRecommendationsByPrice() async {
    return await ref
        .read(recommendationsRepositoryProvider)
        .getRecommendationsByPrice();
  }

  List<Recommendation> getRecommendations() {
    return ref.read(recommendationsRepositoryProvider).getRecommendations();
  }

  void logout() {
    return ref.read(recommendationsRepositoryProvider).logout();
  }
}
