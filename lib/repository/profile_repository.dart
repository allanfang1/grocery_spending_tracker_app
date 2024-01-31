import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/model/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository();

  late final User user;

  Future<Object> login(String email, String password) async {
    // user = User.fromJson(
    //     '{"email": "a@mail.com", "token": "bbba", "firstname": "allan", "lastname": "fang"}');
    // return 200;
    final response = await http.post(
        Uri(scheme: 'https', host: Constants.HOST, path: Constants.LOGIN_PATH),
        body: {'email': email, 'password': Helper.encrypt(password)});
    if (response.statusCode == 200) {
      user = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {}
    return response.statusCode;
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository();
}
