import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_spending_tracker_app/common/constants.dart';

class UserDataViewModel extends ChangeNotifier {
  String _userEmail = "";
  String _token = "";

  Future<Object> login(String email, String password) async {
    // return 200;
    final response = await http.post(
        Uri(scheme: 'http', host: Constants.HOST, path: Constants.LOGIN_PATH),
        body: {'email': email, 'password': Helper.encrypt(password)});
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _userEmail = email;
      _token = data['token'];
      notifyListeners();
    } else {}
    return response.statusCode;
  }

  // String getToken() {
  //   return _token;
  // }
}
