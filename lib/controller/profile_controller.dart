import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {}

  Future<Response> login(String email, String password) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    return await profileRepository.login(email, password);
  }

  Future<Response> register(
      String firstname, String lastname, String email, String password) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    return await profileRepository.register(
        firstname, lastname, email, password);
  }

  void logout() {
    final profileRepository = ref.read(profileRepositoryProvider);
    profileRepository.logout();
  }
}
