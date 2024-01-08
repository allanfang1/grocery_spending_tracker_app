class ExtractData {
  // extract date from the input receipt text if it exists
  String? getDate(String receiptData) {
    final dateRegex = RegExp(
        r'^(\d{1,2})[/\-](\d{1,2})[/\-](\d{4})');
    String? date = dateRegex.stringMatch(receiptData);

    return date;
  }
}
