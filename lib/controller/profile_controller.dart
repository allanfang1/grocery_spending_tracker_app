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
    return await ref.read(profileRepositoryProvider).login(email, password);
  }

  Future<Response> register(
      String firstname, String lastname, String email, String password) async {
    return await ref
        .read(profileRepositoryProvider)
        .register(firstname, lastname, email, password);
  }

  User getUser() {
    return ref.read(profileRepositoryProvider).user;
  }

  Future<Response> updateUser(String firstname, String lastname) {
    return ref
        .read(profileRepositoryProvider)
        .updateUser(firstname, lastname); // add redundancy logic
  }

  void logout() {
    ref.read(profileRepositoryProvider).logout();
  }
}
