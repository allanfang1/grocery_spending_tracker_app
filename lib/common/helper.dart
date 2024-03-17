import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class Helper {
  static String encrypt(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static String currencyFormat(double? val) {
    return val != null ? NumberFormat.currency(symbol: "\$").format(val) : "";
  }

  static String dateTimeToString(DateTime? dateTime) {
    return dateTime != null ? DateFormat('MMM d, yyyy').format(dateTime) : "";
  }
}
