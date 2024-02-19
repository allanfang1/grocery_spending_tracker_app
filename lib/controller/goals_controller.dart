import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/repository/goals_repository.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goals_controller.g.dart';

@riverpod
class GoalsController extends _$GoalsController {
  @override
  Future<FutureOr<void>> build() async {}

  Future<Response> createGoal(
      DateTime startDate, DateTime endDate, String budget) async {
    return await ref.read(goalsRepositoryProvider).createGoal(
        DateFormat('yyyy-MM-dd').format(startDate),
        DateFormat('yyyy-MM-dd').format(endDate),
        double.parse(budget));
  }
}
