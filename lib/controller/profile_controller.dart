import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// This file defines the ProfileController class, responsible for managing user profile related functionalities.

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  // Override the build method of the parent class to return the current user.
  @override
  FutureOr<User> build() {
    return ref.read(profileRepositoryProvider).user;
  }

  // Method to log in a user with the provided email and password.
  Future<Response> login(String email, String password) async {
    Response response =
        await ref.read(profileRepositoryProvider).login(email, password);
    state = AsyncValue.data(ref.read(profileRepositoryProvider).user);
    return response;
  }

  // Method to register a new user with the provided details.
  Future<Response> register(
      String firstname, String lastname, String email, String password) async {
    return await ref
        .read(profileRepositoryProvider)
        .register(firstname, lastname, email, password);
  }

  // Method to retrieve the current user.
  User getUser() {
    return ref.read(profileRepositoryProvider).user;
  }

  // Method to update user information with provided firstname and lastname.
  Future<Response> updateUser(String firstname, String lastname) async {
    Response response = await ref
        .read(profileRepositoryProvider)
        .updateUser(firstname, lastname); // add redundancy logic
    await ref.read(profileRepositoryProvider).getUser();
    state = AsyncValue.data(ref.read(profileRepositoryProvider).user);
    return response;
  }

  // Method to log out the current user.
  void logout() {
    ref.read(profileRepositoryProvider).logout();
  }
}
