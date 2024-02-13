import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/model/goal.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/goals_repository.dart';
import 'package:grocery_spending_tracker_app/repository/history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

class AnalyticsService {
  AnalyticsService(this.ref);
  final Ref ref;

  Future<List<dynamic>> getLiveGoals() async {
    await ref.watch(goalsRepositoryProvider).getGoals();
    await ref.watch(historyRepositoryProvider).loadTransactions();
    final goals = ref.watch(goalsRepositoryProvider).goals;
    final transactions = ref.watch(historyRepositoryProvider).transactions;

    List<dynamic> response = [];
    for (Goal goal in goals) {
      Duration difference = goal.endDate!.difference(DateTime.now());

      List<Transaction> transactionsInRange = transactions
          .where((transaction) =>
              transaction.dateTime!.isAfter(goal.startDate!) &&
              transaction.dateTime!.isBefore(goal.endDate!))
          .toList();

      double spendingTotal = transactionsInRange.fold(0.0,
          (previousValue, transaction) => previousValue + transaction.total!);
      double progress = spendingTotal / goal.budget!;
      response.add([goal, spendingTotal, difference.inDays, progress].toList());
    }
    print(response);

    return response;
  }
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService(ref);
}
