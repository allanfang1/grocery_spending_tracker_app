import 'package:test/test.dart';
import 'package:grocery_spending_tracker_app/controller/extract_data.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';

void main() {
  // Unit tests to verify DateTime extraction from strings/receipt text
  group('DateTime Extraction Tests', () {
    /**
     * FRT-M3-1
     * Input: A list of strings where no string has a valid date
     * Output: Unix timestamp for DateTime.now()
     * Derivation: No valid date is picked up from the OCR
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
     * Input: A list of strings where one string has the format YY/MM/DD HH:MM
     * as would appear on a receipt
     * Output: Unix timestamp corresponding with extracted date
     * Derivation: The OCR finds a DateTime of format YY/MM/DD HH:MM
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
     * Input: A list of strings where one string has the format YY/MM/DD HH:MM:SS
     * Output: Unix timestamp corresponding with extracted date
     * Derivation: The OCR finds a DateTime of format YY/MM/DD HH:MM:SS
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
     * Input: A list of strings where one string has the format YY-MM-DD HH:MM:SS
     * Output: Unix timestamp corresponding with extracted date
     * Derivation: The OCR finds a DateTime of format YY-MM-DD HH:MM:SS
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
     * Input: A list of strings where multiple strings have valid dates
     * Output: Unix timestamp corresponding with first match
     * Derivation: The OCR picks up multiple possible DateTimes
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
     * Input: An empty list of strings
     * Output: Unix timestamp for DateTime.now()
     * Derivation: The OCR is unable to find any text
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
     * Input: An array of strings where one string matches a stored/expected grocery store
     * Output: The address of the corresponding grocery store
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
     * FRT-M3-8
     * Input: An array of strings where one string contains the Hamilton Fortinos address but in
     * a different format from how it is stored
     * Output: The address of the corresponding grocery store
     * Derivation: The OCR finds an address string that references a supported grocery store but written
     * differently from how it is stored
     */
    test('Similar address is properly extracted and matched', () {
      List<String> input = [
        '1579 Main Street West',
        'Product 4.99',
      ];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[0]);
    });

    /**
     * FRT-M3-9
     * Input: An array of strings where one string contains the Hamilton Westside Food Basics address but in
     * a different format from how it is stored
     * Output: The address of the corresponding grocery store
     * Derivation: The OCR finds an address string that references a supported grocery store but written
     * differently from how it is stored
     */
    test('Similar address is properly extracted and matched', () {
      List<String> input = [
        'Product 4.99',
        '845 King St W, L8S 1K4'
      ];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[1]);
    });

    /**
     * FRT-M3-10
     * Input: An array of strings where one string contains the Hamilton Nations address but in
     * a different format from how it is stored
     * Output: The address of the corresponding grocery store
     * Derivation: The OCR finds an address string that references a supported grocery store but written
     * differently from how it is stored
     */
    test('Similar address is properly extracted and matched', () {
      List<String> input = [
        'Product 4.99',
        '2 King St W #445'
      ];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[2]);
    });

    /**
     * FRT-M3-11
     * Input: An array of strings where one string contains the address of an expected
     * grocery store with errors
     * Output: The address of the corresponding grocery store
     * Derivation: The OCR produces a typo when scanning for the address
     */
    test('Similar address is properly extracted and matched', () {
      List<String> input = [
        '1678 Main Street Wst'
      ];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, Constants.ADDRESSES[0]);
    });

    /**
     * FRT-M3-12
     * Input: An empty array of strings
     * Output: An empty string is returned
     * Derivation: The OCR is unable to find any text and user must manually input an
     * address
     */
    test('Extraction of address from empty input', () {
      List<String> input = [];
      final extractedAddress = ExtractData().getLocation(input);
      expect(extractedAddress, '');
    });

    /**
     * FRT-M3-13
     * Input: An array of strings where no string is an address
     * Output: An empty string is returned
     * Derivation: The OCR is unable to find any address and the user must manually
     * input an address
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
  });
}
