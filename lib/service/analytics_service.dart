import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/model/goal.dart';
import 'package:grocery_spending_tracker_app/model/live_goal.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/goals_repository.dart';
import 'package:grocery_spending_tracker_app/repository/history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

class AnalyticsService {
  AnalyticsService(this.ref);
  final Ref ref;
  List<LiveGoal> liveGoals = [];

  Future<void> refreshGoals() async {
    await ref.watch(goalsRepositoryProvider).getGoals();
  }

  Future<void> refreshTransactions() async {
    await ref.watch(historyRepositoryProvider).loadTransactions();
  }

  Future<void> loadLiveGoals() async {
    final goals = ref.watch(goalsRepositoryProvider).goals;
    final transactions = ref.watch(historyRepositoryProvider).transactions;

    List<LiveGoal> newLiveGoals = [];
    for (Goal goal in goals) {
      List<Transaction> transactionsInRange = transactions
          .where((transaction) =>
              transaction.dateTime.isAfter(goal.startDate) &&
              transaction.dateTime.isBefore(goal.endDate))
          .toList();

      newLiveGoals.add(LiveGoal(goal, transactionsInRange));
    }
    liveGoals = newLiveGoals;
  }
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService(ref);
}
