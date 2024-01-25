import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_spending_tracker_app/common/constants.dart';

class TransactionHistoryViewModel extends ChangeNotifier {
  List<Transaction> _transactionHistoryList = [];

  Future<Object> login(String email, String password) async {
    return 200;
    // final response = await http.post(Uri.parse(Constants.LOGIN_URL),
    //     body: {'email': email, 'password': encryptPassword(password)});
    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> data = json.decode(response.body);
    //   _userEmail = email;
    //   _token = data['token'];
    //   notifyListeners();
    // } else {}
    // return response.statusCode;
  }

  // String getToken() {
  //   return _token;
  // }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
