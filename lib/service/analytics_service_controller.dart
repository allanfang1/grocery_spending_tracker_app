import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/model/live_goal.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/service/analytics_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service_controller.g.dart';

@riverpod
class AnalyticsServiceController extends _$AnalyticsServiceController {
  int selectedIndex = -1;

  @override
  Future<List<LiveGoal>> build() async {
    final analyticsService = ref.read(analyticsServiceProvider);
    await analyticsService.refreshGoals();
    await analyticsService.refreshTransactions();
    await analyticsService.loadLiveGoals();
    return analyticsService.liveGoals;
  }

  Future<void> refreshGoals() async {
    final analyticsService = ref.read(analyticsServiceProvider);
    state = const AsyncLoading();
    await analyticsService.loadLiveGoals();
    state = AsyncValue.data(analyticsService.liveGoals);
  }

  LiveGoal? getLiveGoalByIndex() {
    return selectedIndex != -1
        ? ref.read(analyticsServiceProvider).liveGoals[selectedIndex]
        : null;
  }

  List<BarChartGroupData> getBarChartGroupDataByIndex() {
    LiveGoal liveGoal =
        ref.read(analyticsServiceProvider).liveGoals[selectedIndex];
    DateTime endDate = DateTime.now().isBefore(liveGoal.goal.endDate)
        ? DateTime.now()
        : liveGoal.goal.endDate;

    List<BarChartGroupData> result = [];
    int resultCounter = 0;
    //for every day from start of goal to (today or goal end date)
    for (DateTime date = liveGoal.goal.startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      double barLen = 0.0;
      for (Transaction transaction in liveGoal.transactions) {
        if (DateUtils.isSameDay(date, transaction.dateTime)) {
          barLen += transaction.total;
        }
      }
      result.add(BarChartGroupData(
          x: resultCounter, barRods: [BarChartRodData(toY: barLen)]));
      resultCounter += 1;
    }
    return result;
  }
}
