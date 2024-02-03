import 'dart:convert';

import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test("Testing the network call", () async {
    final profileRepository = ProfileRepository();
    profileRepository.client = MockClient((request) async {
      final mapJson = {
        'email': "a@a.com",
      };
      return Response(json.encode(mapJson), 200);
    });
    final response = await profileRepository.login("bob", "uncle");
    expect(response, 200);
    expect(profileRepository.user.email, "a@a.com");
  });
}
