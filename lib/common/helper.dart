import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

/// A helper class containing utility methods.
class Helper {
  /// Encrypts the given [password] using SHA-256 hashing algorithm.
  static String encrypt(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Formats the given currency value [val] into a string with a dollar symbol.
  static String currencyFormat(double? val) {
    return val != null ? NumberFormat.currency(symbol: "\$").format(val) : "";
  }

  /// Converts the given [dateTime] to a string in the format 'MMM d, yyyy'.
  static String dateTimeToString(DateTime? dateTime) {
    return dateTime != null ? DateFormat('MMM d, yyyy').format(dateTime) : "";
  }
}
