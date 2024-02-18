import 'package:grocery_spending_tracker_app/model/live_goal.dart';
import 'package:grocery_spending_tracker_app/service/analytics_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service_controller.g.dart';

@riverpod
class AnalyticsServiceController extends _$AnalyticsServiceController {
  @override
  Future<List<LiveGoal>> build() async {
    final analyticsService = ref.read(analyticsServiceProvider);
    return await analyticsService.getLiveGoals();
  }
}
