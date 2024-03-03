import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<User> build() {
    return ref.read(profileRepositoryProvider).user;
  }

  Future<Response> login(String email, String password) async {
    Response response =
        await ref.read(profileRepositoryProvider).login(email, password);
    state = AsyncValue.data(ref.read(profileRepositoryProvider).user);
    return response;
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

  Future<Response> updateUser(String firstname, String lastname) async {
    Response response = await ref
        .read(profileRepositoryProvider)
        .updateUser(firstname, lastname); // add redundancy logic
    await ref.read(profileRepositoryProvider).getUser();
    state = AsyncValue.data(ref.read(profileRepositoryProvider).user);
    return response;
  }

  void logout() {
    ref.read(profileRepositoryProvider).logout();
  }
}
