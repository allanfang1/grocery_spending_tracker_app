import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:grocery_spending_tracker_app/service/analytics_service.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service_controller.g.dart';

@riverpod
class AnalyticsServiceController extends _$AnalyticsServiceController {
  @override
  Future<List<dynamic>> build() async {
    final analyticsService = ref.read(analyticsServiceProvider);
    return await analyticsService.getLiveGoals();
  }
}
