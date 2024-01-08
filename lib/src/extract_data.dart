class ExtractData {
  // extract date and time from the input receipt text if it exists
  String? getDateTime(String receiptData) {
    final dateTimeRegex = RegExp(
        r'(\d{1,2})[/\-](\d{1,2})[/\-](\d{4}) ([0-1]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?');
    String? dateTime = dateTimeRegex.stringMatch(receiptData);

    return dateTime;
  }
}
