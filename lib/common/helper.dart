import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class Helper {
  static String encrypt(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static String priceFormat(int? val) {
    return val != null
        ? NumberFormat.currency(symbol: "\$").format(val / 100.0)
        : "";
  }

  static String dateTimeToString(DateTime? dateTime) {
    return dateTime != null ? DateFormat('MMM dd yyyy').format(dateTime) : "";
  }
}
