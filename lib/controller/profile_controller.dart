import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {}

  Future<Object> login(String email, String password) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    return await profileRepository.login(email, Helper.encrypt(password));
  }

  Future<Object> register(String email, String password) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    return await profileRepository.register(email, Helper.encrypt(password));
  }
}
