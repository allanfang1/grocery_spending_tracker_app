import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/model/goal.dart';
import 'package:grocery_spending_tracker_app/model/live_goal.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/goals_repository.dart';
import 'package:grocery_spending_tracker_app/repository/history_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Service class for managing analytics.

part 'analytics_service.g.dart';

class AnalyticsService {
  AnalyticsService(this.ref);
  final Ref ref;
  List<LiveGoal> liveGoals = [];

  // Method to refresh goals.
  Future<void> refreshGoals() async {
    await ref.watch(goalsRepositoryProvider).loadGoals();
  }

  // Method to refresh transactions.
  Future<void> refreshTransactions() async {
    await ref.watch(historyRepositoryProvider).loadTransactions();
  }

  // Method to load live goals.
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

  // Method to delete a goal.
  Future<void> deleteGoal(int index) async {
    Response response =
        await ref.watch(goalsRepositoryProvider).deleteGoal(index);
    if (response.statusCode == 200) {
      liveGoals.removeAt(index);
    }
  }
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService(ref);
}
