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
        var temp = "20$line";

        if (temp.contains("/")) temp = temp.replaceAll("/", "-");

        parsedDate = DateTime.parse(temp);
      }
    }

    final dateTime = parsedDate.millisecondsSinceEpoch~/1000;

    return dateTime;
  }

  // extract location of store if available
  String getLocation(List<String> receiptData) {
    // Full Street Address, City, Province, Postal Code
    // r'([1-9]+) [a-zA-Z\s]+(\,)? [a-zA-Z]+(\,)? ([A-Z]{2})+(\,)? [A-Z0-9\s]{6,7}'

    // want to add optional city, province and postal
    final addressRegex = RegExp(r'([1-9]+) [a-zA-Z\s]');

    for (String line in receiptData) {
      if (addressRegex.hasMatch(line)) return line;
    }

    return "";
  }

  // extracts grocery items from receipt data
  List<String> getItems(List<String> receiptData) {
    List<String> groceries = [];

    final itemRegex = RegExp(r'([a-zA-Z\s]+) [$]?[0-9]+.[0-9\s]{2,3}');

    for (String line in receiptData) {
      if (itemRegex.hasMatch(line)) groceries.add(line);
    }

    return groceries;
  }

  // gets subtotal from receipt
  String getSubtotal(List<String> receiptData) {
    final subtotalRegex = RegExp(r'(Subtotal|SUBTOTAL) [$]?[0-9]+.[0-9]{2}');

    for (String line in receiptData) {
      if (subtotalRegex.hasMatch(line)) return line;
    }

    return "";
  }

  // gets total from receipt
  String getTotal(List<String> receiptData) {
    final subtotalRegex = RegExp(r'(Total|TOTAL) [$]?[0-9]+.[0-9]{2}');

    for (String line in receiptData) {
      if (subtotalRegex.hasMatch(line)) return line;
    }

    return "";
  }

}
