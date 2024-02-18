import 'package:grocery_spending_tracker_app/model/goal.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';

class LiveGoal {
  late Goal goal;
  late String status;
  late double spendingTotal;
  late int daysRemaining;
  late double progressPercent;

  LiveGoal(Goal goal, List<Transaction> transactions) {
    goal = goal;
    spendingTotal = transactions.fold(
        0.0, (prevValue, transaction) => prevValue + transaction.total);
    daysRemaining = goal.endDate.difference(DateTime.now()).inDays;
    progressPercent = spendingTotal / goal.budget;
    if (daysRemaining < 0) {
      status = "expired";
    } else if (progressPercent >= 1) {
      status = "complete";
    } else {
      status = "live";
    }
  }
}