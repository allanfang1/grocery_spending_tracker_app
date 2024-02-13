import 'dart:convert';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository();
  Client client = Client();

  final User user = User.empty();

  Future<Response> login(String email, String password) async {
    Response response =
        await client.post(Uri.parse(Constants.HOST + Constants.LOGIN_PATH),
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

  Future<Response> getUser() async {
    final response = await client.get(
        Uri.parse(
            Constants.HOST + Constants.GET_USER_PATH + user.id!.toString()),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Auth': user.token!,
        });
    if (response.statusCode == 200) {
      user.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    return response;
  }

  Future<Response> register(
      String firstname, String lastname, String email, String password) async {
    final response =
        await client.post(Uri.parse(Constants.HOST + Constants.REGISTER_PATH),
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

  void logout() {
    user.clear();
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository();
}
