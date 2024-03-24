import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/levenshtein.dart';

class ExtractData {
  // need to separate out the lines of text in order to more easily parse
  // and improve quality of outputs from RegExp
  List<String> textToList(String receiptData) {
    List<String> splitReceipt = receiptData.split('\n');

    for (int i = 0; i < splitReceipt.length; i++) {
      String singleLine = splitReceipt[i].replaceAll('\n', '');
      splitReceipt[i] = singleLine;
    }

    return splitReceipt;
  }

  // extract date and time from the input receipt text if it exists
  int getDateTime(List<String> receiptData) {
    final dateTimeRegex = RegExp(
        r'(\d{1,2})[/\-](\d{1,2})[/\-](\d{1,2}) ([0-1]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?');
    var parsedDate = DateTime.now();

    for (String line in receiptData) {
      if (dateTimeRegex.hasMatch(line)) {
        List<String> splitLine = line.split(' ');
        if (splitLine.length == 3) splitLine.removeAt(0);
        line = splitLine.join(' ');

        var temp = "20$line";

        if (temp.contains("/")) temp = temp.replaceAll("/", "-");

        try {
          parsedDate = DateTime.parse(temp);
          break;
        } on FormatException {
          return DateTime.now().millisecondsSinceEpoch ~/ 1000;
        }
      }
    }

    return parsedDate.millisecondsSinceEpoch ~/ 1000;
  }

  // extract location of store if available
  String getLocation(List<String> receiptData) {
    // Full Street Address, City, Province, Postal Code
    // r'([1-9]+) [a-zA-Z\s]+(\,)? [a-zA-Z]+(\,)? ([A-Z]{2})+(\,)? [A-Z0-9\s]{6,7}'

    // want to add optional city, province and postal
    final addressRegex = RegExp(r'([1-9]+) [a-zA-Z\s]');
    int minDistance = 0x7FFFFFFFFFFFFFFF; // max int
    String storeAddress = '';

    for (String line in receiptData) {
      if (addressRegex.hasMatch(line)) {
        for (String address in Constants.ADDRESSES) {
          int distance = levenshtein(line, address);
          if (distance < minDistance) {
            minDistance = distance;
            storeAddress = address;
          }
        }
        return storeAddress;
      }
    }

    return "";
  }

  // extracts grocery items from receipt data
  List<String> getItems(List<String> receiptData) {
    List<String> groceries = [];

    final itemRegex = RegExp(r'([a-zA-Z\s]+) [$]?[0-9]+.[0-9\s]{2,3}');
    final priceRegex = RegExp(r'[$]?[0-9]+[.\s]{2}');

    for (String line in receiptData) {
      if (itemRegex.hasMatch(line) &&
          !line.contains(RegExp('TOTAL', caseSensitive: false)) &&
          !line.contains(RegExp('SUBTOTAL', caseSensitive: false)) &&
          !line.contains('%')) {
        // correct OCR parsing if there is a space captured in the price
        if (priceRegex.hasMatch(line)) {
          int temp = line.lastIndexOf(' ');
          line = line.replaceRange(temp, temp + 1, '');
        }

        groceries.add(line);
      }
    }

    return groceries;
  }

  // gets subtotal from receipt
  String getSubtotal(List<String> receiptData) {
    final subtotalRegex = RegExp(r'^(Subtotal|SUBTOTAL) [$]?[0-9]+.[0-9\s]{2,3}');
    final priceRegex = RegExp(r'[$]?[0-9]+[.\s]{2}');

    for (String line in receiptData) {
      if (subtotalRegex.hasMatch(line)) {
        if (priceRegex.hasMatch(line)) {
          int temp = line.lastIndexOf(' ');
          line = line.replaceRange(temp, temp + 1, '');
        }
        return line;
      }
    }

    return "SUBTOTAL 0.00";
  }

  // gets total from receipt
  String getTotal(List<String> receiptData) {
    final totalRegex = RegExp(r'^(Total|TOTAL) [$]?[0-9]+.[0-9\s]{2,3}');
    final priceRegex = RegExp(r'[$]?[0-9]+[.\s]{2}');

    for (String line in receiptData) {
      if (totalRegex.hasMatch(line)) {
        if (priceRegex.hasMatch(line)) {
          int temp = line.lastIndexOf(' ');
          line = line.replaceRange(temp, temp + 1, '');
        }
        return line;
      }
    }

    return "TOTAL 0.00";
  }
}
