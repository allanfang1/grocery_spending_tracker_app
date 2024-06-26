import 'package:test/test.dart';
import 'package:grocery_spending_tracker_app/controller/extract_data.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/model/grocery_trip.dart';
import 'package:grocery_spending_tracker_app/model/capture_item.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  // Unit tests to verify DateTime extraction from strings/receipt text
  group('DateTime Extraction Tests', () {
    /**
     * FRT-M3-1
     * Initial State: The OCR has just scanned a receipt.
     * Input: A list of strings where no string has a valid date.
     * Output: Unix timestamp for the current time.
     * Derivation: No valid date is picked up from the OCR.
     */
    test('Extraction of date if no valid date is found', () {
      List<String> input = [
        'String',
        'Partial date: 02/24',
        'Time: 12:22:33',
        ''
      ];
      final extractedDate = ExtractData().getDateTime(input);
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      expect(extractedDate, currentTime);
    });

    /**
     * FRT-M3-2
     * Initial State: The OCR has just scanned a receipt.
     * Input: A list of strings where one string has the format YY/MM/DD HH:MM
     * as would appear on a receipt.
     * Output: Unix timestamp corresponding with extracted date.
     * Derivation: The OCR finds a DateTime of format YY/MM/DD HH:MM.
     */
    test('Extraction of date with format DateTime: YY/MM/DD HH:MM', () {
      List<String> input = [
        'Just String',
        'DateTime: 23/05/12 12:30',
        'String'
      ];
      final extractedDate = ExtractData().getDateTime(input);
      final expectedDate =
          DateTime.parse('2023-05-12 12:30').millisecondsSinceEpoch ~/ 1000;
      expect(extractedDate, expectedDate);
    });

    /**
     * FRT-M3-3
     * Initial State: The OCR has just scanned a receipt.
     * Input: A list of strings where one string has the format YY/MM/DD HH:MM:SS.
     * Output: Unix timestamp corresponding with extracted date.
     * Derivation: The OCR finds a DateTime of format YY/MM/DD HH:MM:SS.
     */
    test('Extraction of date with format YY/MM/DD HH:MM:SS', () {
      List<String> input = [
        'Just String',
        '',
        'String',
        'DateTime: 23/05/12 12:30:24'
      ];
      final extractedDate = ExtractData().getDateTime(input);
      final expectedDate =
          DateTime.parse('2023-05-12 12:30:24').millisecondsSinceEpoch ~/ 1000;
      expect(extractedDate, expectedDate);
    });

    /**
     * FRT-M3-4
     * Initial State: The OCR has just scanned a receipt.
     * Input: A list of strings where one string has the format YY-MM-DD HH:MM:SS.
     * Output: Unix timestamp corresponding with extracted date.
     * Derivation: The OCR finds a DateTime of format YY-MM-DD HH:MM:SS.
     */
    test('Extraction of date with format YY-MM-DD HH:MM:SS', () {
      List<String> input = ['22-12-24 23:30:20', 'String', 'Different String'];
      final extractedDate = ExtractData().getDateTime(input);
      final expectedDate =
          DateTime.parse('2022-12-24 23:30:20').millisecondsSinceEpoch ~/ 1000;
      expect(extractedDate, expectedDate);
    });

    /**
     * FRT-M3-5
     * Initial State: The OCR has just scanned a receipt.
     * Input: A list of strings where multiple strings have valid dates.
     * Output: Unix timestamp corresponding with first match.
     * Derivation: The OCR picks up multiple possible date and times.
     */
    test('Extraction of date with multiple matches', () {
      List<String> input = [
        'Date: 24/01/01 00:38:56',
        'Time: 22-12-24 23:30:20',
        'DateTime: 21/07/12 11:57:57'
      ];
      final extractedDate = ExtractData().getDateTime(input);
      final expectedDate =
          DateTime.parse('2024-01-01 00:38:56').millisecondsSinceEpoch ~/ 1000;
      expect(extractedDate, expectedDate);
    });

    /**
     * FRT-M3-6
     * Initial State: The OCR has just scanned a receipt.
     * Input: An empty list of strings.
     * Output: Unix timestamp for the current time.
     * Derivation: The OCR is unable to find any text.
     */
    test('Extraction of date with an empty input', () {
      final extractedDate = ExtractData().getDateTime([]);
      final expectedDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      expect(extractedDate, expectedDate);
    });
  });

  // Unit tests to verify address extraction from strings/receipt text
  group('Address Extraction Tests', () {
    /**
     * FRT-M3-7
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings where no string is an address.
     * Output: An empty string is returned.
     * Derivation: The OCR is unable to find any address and the user must manually
     * input an address.
     */
    test('Extraction of address from empty input', () {
      List<String> input = [
        'Fortinos',
        'Product H 2.98',
        'Product 3.99',
        'Total 7.00'
      ];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, '');
    });

    /**
     * FRT-M3-8
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings where one string matches a stored/expected grocery store.
     * Output: The address of the corresponding grocery store.
     * Derivation: The OCR finds an address string that matches an address supported by the app.
     */
    test('Address is properly extracted and matched', () {
      List<String> input = [
        'not an address',
        '845 King Street West, Hamilton, ON L8S 1K4',
        'Product 3.89'
      ];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[1]);
    });

    /**
     * FRT-M3-9
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings where one string contains the Hamilton Fortinos address but in
     * a different format from how it is stored.
     * Output: The address of the corresponding grocery store.
     * Derivation: The OCR finds an address string that references a supported grocery store but written
     * differently from how it is stored.
     */
    test('Similar address to Fortinos is properly extracted and matched', () {
      List<String> input = [
        '1579 Main Street West',
        'Product 4.99',
      ];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[0]);
    });

    /**
     * FRT-M3-10
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings where one string contains the Hamilton Westside Food Basics address but in
     * a different format from how it is stored.
     * Output: The address of the corresponding grocery store.
     * Derivation: The OCR finds an address string that references a supported grocery store but written
     * differently from how it is stored.
     */
    test('Similar address to Food Basics is properly extracted and matched',
        () {
      List<String> input = ['Product 4.99', '845 King St W, L8S 1K4'];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[1]);
    });

    /**
     * FRT-M3-11
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings where one string contains the Hamilton Nations address but in
     * a different format from how it is stored.
     * Output: The address of the corresponding grocery store.
     * Derivation: The OCR finds an address string that references a supported grocery store but written
     * differently from how it is stored.
     */
    test('Similar address to Nations is properly extracted and matched', () {
      List<String> input = ['Product 4.99', '2 King St W #445'];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[2]);
    });

    /**
     * FRT-M3-12
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings where one string contains the address of an expected
     * grocery store with errors.
     * Output: The address of the corresponding grocery store.
     * Derivation: The OCR produces a typo when scanning for the address.
     */
    test('Similar address is properly extracted and matched', () {
      List<String> input = ['1678 Man Street Wst'];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[0]);
    });

    /**
     * FRT-M3-13
     * Initial State: The OCR has just scanned a receipt.
     * Input: An empty array of strings.
     * Output: An empty string.
     * Derivation: The OCR is unable to find any text and user must manually input an
     * address.
     */
    test('Extraction of address from empty input', () {
      List<String> input = [];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, '');
    });
  });

  // Unit tests to verify item extraction from strings/receipt text
  group('Item Extraction Tests', () {
    /**
     * FRT-M3-14
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings without items.
     * Output: An empty array of strings is returned.
     * Derivation: The OCR is unable to find any items when scanning the receipt. This includes
     * excluding subtotal and total which will be handled separately in the extraction process.
     */
    test('Extraction of items if no items are found', () {
      List<String> input = [
        'FORTINOS (1579 Main Street)',
        'Thank you for visiting',
        'Subtotal 4.99',
        'Total 5.12'
      ];
      final extractedItems = ExtractData().getItems(input);
      expect(extractedItems, []);
    });

    /**
     * FRT-M3-15
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings with multiple items.
     * Output: An array of strings containing the expected items.
     * Derivation: The OCR finds various items from scanning the receipt.
     */
    test('Extraction of items if items are found', () {
      List<String> input = [
        'FORTINOS (1579 Main Street)',
        'Thank you for visiting',
        '413205 ProductOne H 3.00',
        '3829 ProductTwo 4.00',
        'Subtotal 7.00',
        'Total 7.39'
      ];
      final extractedItems = ExtractData().getItems(input);
      expect(
          extractedItems, ['413205 ProductOne H 3.00', '3829 ProductTwo 4.00']);
    });

    /**
     * FRT-M3-16
     * Initial State: The OCR has just scanned a receipt.
     * Input: An empty array of strings.
     * Output: An empty array of items.
     * Derivation: The OCR is unable to pick up any text during scanning.
     */
    test('Extraction of items from empty input', () {
      List<String> input = [];
      final extractedItems = ExtractData().getItems(input);
      expect(extractedItems, []);
    });
  });

  // Unit tests to verify the subtotal extraction from strings/receipt text
  group('Subtotal Extraction Tests', () {
    /**
     * FRT-M3-17
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings without a subtotal being present.
     * Output: A default string text that is returned if no subtotal is found.
     * Derivation: The OCR is unable to find a subtotal during scanning.
     */
    test('Extraction of subtotal if subtotal is not found', () {
      List<String> input = [
        'FORTINOS (1579 Main Street)',
        'Thank you for visiting',
        '413205 ProductOne H 3.00',
        '3829 ProductTwo 4.00',
      ];
      final extractedSubtotal = ExtractData().getSubtotal(input);
      expect(extractedSubtotal, 'SUBTOTAL 0.00');
    });

    /**
     * FRT-M3-18
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings with a subtotal present.
     * Output: The subtotal string from the list.
     * Derivation: The OCR finds the subtotal of the trip while scanning.
     */
    test('Extraction of subtotal if subtotal is found', () {
      List<String> input = [
        'FORTINOS (1579 Main Street)',
        'Thank you for visiting',
        '413205 ProductOne H 3.00',
        'Subtotal 3.00',
        'Total 3.39'
      ];
      final extractedSubtotal = ExtractData().getSubtotal(input);
      expect(extractedSubtotal, 'Subtotal 3.00');
    });

    /**
     * FRT-M3-19
     * Initial State: The OCR has just scanned a receipt.
     * Input: An empty array of strings.
     * Output: A default string text that is returned if no subtotal is found.
     * Derivation: The OCR is unable to pick up any text during scanning.
     */
    test('Extraction of subtotal from empty input', () {
      List<String> input = [];
      final extractedSubtotal = ExtractData().getSubtotal(input);
      expect(extractedSubtotal, 'SUBTOTAL 0.00');
    });
  });

  // Unit tests to verify the total extraction from strings/receipt text
  group('Total Extraction Tests', () {
    /**
     * FRT-M3-20
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings without a total being present.
     * Output: A default string text that is returned if no total is found.
     * Derivation: The OCR is unable to find a total during scanning.
     */
    test('Extraction of total if total is not found', () {
      List<String> input = [
        'FORTINOS (1579 Main Street)',
        'Thank you for visiting',
        '413205 ProductOne H 3.00',
        '3829 ProductTwo 4.00',
        'Subtotal 3.00'
      ];
      final extractedSubtotal = ExtractData().getTotal(input);
      expect(extractedSubtotal, 'TOTAL 0.00');
    });

    /**
     * FRT-M3-21
     * Initial State: The OCR has just scanned a receipt.
     * Input: An array of strings with a total present.
     * Output: The total string from the list.
     * Derivation: The OCR finds the total of the trip while scanning.
     */
    test('Extraction of total if total is found', () {
      List<String> input = [
        'FORTINOS (1579 Main Street)',
        'Thank you for visiting',
        '413205 ProductOne H 3.00',
        'Subtotal 3.00',
        'Total 3.39'
      ];
      final extractedSubtotal = ExtractData().getTotal(input);
      expect(extractedSubtotal, 'Total 3.39');
    });

    /**
     * FRT-M3-22
     * Initial State: The OCR has just scanned a receipt.
     * Input: An empty array of strings.
     * Output: A default string text that is returned if no total is found.
     * Derivation: The OCR is unable to pick up any text during scanning.
     */
    test('Extraction of total from empty input', () {
      List<String> input = [];
      final extractedSubtotal = ExtractData().getTotal(input);
      expect(extractedSubtotal, 'TOTAL 0.00');
    });
  });

  group('Item and Grocery Trip Object Tests', () {
    /**
     * FRT-M3-23
     * Initial State: An Item has been created.
     * Input: An update is made to all fields.
     * Output: The Item should be updated to match the new input data.
     * Derivation: A user wants to update a grocery item after the OCR finishes
     * scanning.
     */
    test('Item can be updated', () {
      Item test = Item('1', 'ProductOne', 3.99, true);
      test.updateItem('2', 'Updated Name', 5.99, false, false);
      expect(_isMatch(test, Item('2', 'Updated Name', 5.99, false)), true);
    });

    /**
     * FRT-M3-24
     * Initial State: An Item has been created.
     * Input: An existing Item is input.
     * Output: The JSON form of the Item data.
     * Derivation: A user is trying to submit their trip to the backend.
     */
    test('Item to  JSON conversion is working', () {
      Item test = Item('1', 'ProductOne', 3.99, true);
      String json = jsonEncode(test);
      expect(json,
          '{"item_key":"1","item_desc":"ProductOne","price":3.99,"taxed":true}');
    });

    /**
     * FRT-M3-25
     * Initial State: A Grocery Trip has been created.
     * Input: An update is made to all fields.
     * Output: The Grocery Trip should be updated to match the new input data.
     * Derivation: A user wants to update their Grocery Trip after the OCR finishes
     * scanning.
     */
    test('Grocery Trip can be updated', () {
      GroceryTrip trip = GroceryTrip(1706830924, 'FORTINOS (1579 Main Street)',
          [Item('1', 'Product0', 3.89, false)], 3.89, 3.89, '');

      trip.updateGroceryTrip(
          1709336961,
          '1579 Main Street West',
          [
            Item('1', 'Product0', 3.89, false),
            Item('2', 'Product1', 1.00, true)
          ],
          4.89,
          5.02,
          'Test Trip');

      expect(
          trip.dateTime == 1709336961 &&
              trip.location == '1579 Main Street West' &&
              _isMatch(trip.items[0], Item('1', 'Product0', 3.89, false)) &&
              _isMatch(trip.items[1], Item('2', 'Product1', 1.00, true)) &&
              trip.subtotal == 4.89 &&
              trip.total == 5.02,
          true);
    });

    /**
     * FRT-M3-26
     * Initial State: A Grocery Trip has been created.
     * Input: An existing Grocery Trip is input.
     * Output: The JSON form of the Grocery Trip.
     * Derivation: A user tries to submit their grocery trip to the backend.
     */
    test('Grocery Trip to JSON Conversion is Working', () {
      GroceryTrip trip = GroceryTrip(1706830924, 'FORTINOS (1579 Main Street)',
          [Item('1', 'Product0', 3.89, false)], 3.89, 3.89, '');
      String json = jsonEncode(trip);

      final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      String expectedDateTime = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(1706830924 * 1000));

      expect(
          json,
          '{"date_time":"$expectedDateTime","location":"FORTINOS (1579 Main Street)",'
          '"items":[{"item_key":"1","item_desc":"Product0","price":3.89,"taxed":false}],'
          '"subtotal":3.89,"total":3.89,"trip_desc":""}');
    });
  });
}

bool _isMatch(Item a, Item b) {
  if (a.itemKey == b.itemKey &&
      a.itemDesc == b.itemDesc &&
      a.price == b.price &&
      a.taxed == b.taxed &&
      a.deleted == b.deleted) {
    return true;
  }
  return false;
}
