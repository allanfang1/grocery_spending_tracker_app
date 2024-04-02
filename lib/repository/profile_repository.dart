import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Repository class for managing user profile.

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository();
  Client client = Client();

  final User user = User.empty();

  // Method to authenticate user login.
  Future<Response> login(String email, String password) async {
    Response response = await client.post(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.LOGIN_PATH),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'password': password}));
    if (response.statusCode == 200) {
      user.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      response = await getUser();
    }
    print(user.id);
    print(user.token);
    return response;
  }

  // Method to fetch user details.
  Future<Response> getUser() async {
    final response = await client.get(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.GET_USER_PATH),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Auth': user.token!,
        });
    if (response.statusCode == 200) {
      user.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    return response;
  }

  // Method to register a new user.
  Future<Response> register(
      String firstname, String lastname, String email, String password) async {
    final response = await client.post(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.REGISTER_PATH),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'first_name': firstname,
          'last_name': lastname,
          'email': email,
          'password': password,
        }));
    return response;
  }

  // Method to update user details.
  Future<Response> updateUser(String firstname, String lastname) async {
    final response = await client.patch(
        Uri.parse(dotenv.env['BASE_URL']! + Constants.PATCH_USER),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Auth': user.token!,
        },
        body: jsonEncode({
          'first_name': firstname,
          'last_name': lastname,
        }));
    return response;
  }

  // Method to clear user data (logout).
  void logout() {
    user.clear();
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository();
}
