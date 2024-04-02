import 'package:grocery_spending_tracker_app/model/goal.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';

/// Represents a goal with its associated transactions and supplementary information for UI use.
class LiveGoal {
  late Goal goal;
  late List<Transaction> transactions;
  late String status;
  late double spendingTotal;
  late int daysRemaining;
  late double progressPercent;

  /// Constructor for creating a LiveGoal object.
  LiveGoal(Goal inputGoal, List<Transaction> inputTransactions) {
    goal = inputGoal;
    transactions = inputTransactions;
    spendingTotal = transactions.fold(
        0.0, (prevValue, transaction) => prevValue + transaction.total);
    daysRemaining = goal.endDate.difference(DateTime.now()).inDays;
    progressPercent = spendingTotal / goal.budget;
    if (goal.budget == 0) {
      progressPercent = 0;
    }
    if (daysRemaining < 0) {
      status = "expired";
    } else if (progressPercent >= 1) {
      status = "complete";
    } else {
      status = "live";
    }
  }
}
