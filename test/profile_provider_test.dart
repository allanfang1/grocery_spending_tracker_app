import 'dart:convert';

import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  group("Profile Repository Tests", () {
    /*
    FRT-M10-1
    Initial State: A user account has been created
    Input: The correct credentials (email, password)
    Output: A temporary authentication JSON web token
    Derivation: User successfully logs in
    */
    test("Test successful login call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        final mapJson = {'email': "a@a.com", 'token': "yay"};
        return Response(json.encode(mapJson), 200);
      });
      final response = await profileRepository.login("bob", "uncle");
      expect(response.statusCode, 200);
      expect(profileRepository.user.email, "a@a.com");
      expect(profileRepository.user.token, "yay");
    });

    /*
    FRT-M10-2
    Initial State: A user account has not been created
    Input: Credentials that do not exist in the database (email, password)
    Output: A temporary authentication JSON web token
    Derivation: User fails to logs in
    */
    test("Test failed login call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        return Response("Not Found", 400);
      });
      final response = await profileRepository.login("bob", "uncle");
      expect(response.statusCode, 400);
      expect(profileRepository.user.email, null);
      expect(profileRepository.user.token, null);
    });

    /*
    FRT-M10-3
    Initial State: User profile has changed while user is logged in
    Input: n/a 
    Output: User profile (email, firstname, lastname)
    Derivation: Update local user profile 
    */
    test("Test get user call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        final mapJson = {
          'email': "a@a.com",
        };
        return Response(json.encode(mapJson), 200);
      });
      profileRepository.user.token = "bob";
      final response = await profileRepository.getUser();
      expect(response.statusCode, 200);
      expect(profileRepository.user.email, "a@a.com");
    });

    /*
    FRT-M10-4
    Initial State: n/a
    Input: First name, last name, email, password
    Output: User profile created
    Derivation: Register a new user account
    */
    test("Test register call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        return Response("", 200);
      });
      final response =
          await profileRepository.register("allan", "fang", "bob", "uncle");
      expect(response.statusCode, 200);
    });

    /*
    FRT-M10-5
    Initial State: Existing valid user profile currently logged in
    Input: First name, last name
    Output: Confirmation of success
    Derivation: Update user profile
    */
    test("Test update user call", () async {
      final profileRepository = ProfileRepository();
      profileRepository.client = MockClient((request) async {
        return Response("", 200);
      });
      profileRepository.user.token = "bob";
      final response = await profileRepository.updateUser("allan", "fang");
      expect(response.statusCode, 200);
    });
  });
}
