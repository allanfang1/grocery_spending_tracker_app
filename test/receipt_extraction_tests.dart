import 'package:test/test.dart';
import 'package:grocery_spending_tracker_app/controller/extract_data.dart';

void main() {
  // Unit tests to verify DateTime extraction from strings/receipt text
  group('DateTime extraction tests', () {
    /**
     * FRT-M3-1
     * Input: A list of strings where no string has a valid date
     * Output: Unix timestamp for DateTime.now()
     * Derivation: No valid date is picked up from the OCR
     * */
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
     * */
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
     * */
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
     * */
    test('Extraction of date with format YY-MM-DD HH:MM:SS', () {
      List<String> input = [
        '22-12-24 23:30:20',
        'String',
        'Different String'
      ];
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
     * */
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
     * Expected Output: Unix timestamp for DateTime.now()
     * Derivation: The OCR is unable to find any text
     * */
    test('Extraction of date with an empty input', () {
      final extractedDate = ExtractData().getDateTime([]);
      final expectedDate =
          DateTime.now().millisecondsSinceEpoch ~/ 1000;
      expect(extractedDate, expectedDate);
    });
  });
}
