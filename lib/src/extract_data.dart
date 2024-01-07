import 'dart:io';

class ExtractData {
  // List<String> stringToList(String data) {
  //   List<String> splitString = data.split('\n');
  //
  //   return splitString;
  // }

  String getDate(String receiptData) {
    final dateRegex = RegExp(
        r'/^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/');
    RegExpMatch? date = dateRegex.firstMatch(receiptData);

    return date.toString();
  }
}
