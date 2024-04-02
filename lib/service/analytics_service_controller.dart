import 'package:grocery_spending_tracker_app/model/live_goal.dart';
import 'package:grocery_spending_tracker_app/service/analytics_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service_controller.g.dart';

// Controller for managing analytics service.
@riverpod
class AnalyticsServiceController extends _$AnalyticsServiceController {
  int selectedIndex = -1;

  // Override the build method of the parent class to load live goals asynchronously.
  @override
  Future<List<LiveGoal>> build() async {
    final analyticsService = ref.read(analyticsServiceProvider);
    await analyticsService.refreshGoals();
    await analyticsService.refreshTransactions();
    await analyticsService.loadLiveGoals();
    return analyticsService.liveGoals;
  }

  // Method to refresh goals.
  Future<void> refreshGoals() async {
    final analyticsService = ref.read(analyticsServiceProvider);
    state = const AsyncLoading();
    await analyticsService.loadLiveGoals();
    state = AsyncValue.data(analyticsService.liveGoals);
  }

  // Method to get live goal by index.
  LiveGoal getLiveGoalByIndex() {
    return ref.read(analyticsServiceProvider).liveGoals[selectedIndex];
  }

  // Method to delete a goal.
  Future<void> deleteGoal(int index) async {
    final analyticsService = ref.read(analyticsServiceProvider);
    await analyticsService.deleteGoal(index);
    state = AsyncValue.data(analyticsService.liveGoals);
  }
}
