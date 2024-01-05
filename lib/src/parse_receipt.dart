import 'dart:io';

import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ParseReceipt {
  final _receiptScanner = TextRecognizer();

  Future<String> scanReceipt(XFile receipt) async {
    final file = File(receipt.path);
    final inputReceipt = InputImage.fromFile(file);
    final scannedReceipt = await _receiptScanner.processImage(inputReceipt);

    // create list of scanned elements
    List<TextElement> receiptElements = _breakBoxes(scannedReceipt);
    _sortElements(receiptElements, 0, receiptElements.length - 1);

    // reformat scanned elements such that the text is aligned properly
    var receiptText = '';
    for (int i = 0; i < receiptElements.length; i++) {
      if (i == 0) {
        receiptText = '$receiptText${receiptElements[i].text}';
        continue;
      }
      if (_isSameLine(receiptElements[i-1], receiptElements[i])) {
        receiptText = '$receiptText ${receiptElements[i].text}';
      } else {
        receiptText = '$receiptText\n${receiptElements[i].text}';
      }
    }

    return receiptText;
  }

  // used to get all elements into a single list
  List<TextElement> _breakBoxes(RecognizedText text) {
    List<TextElement> textElements = <TextElement>[];

    for (TextBlock blocks in text.blocks) {
      List<TextLine> lines = blocks.lines;

      for (TextLine line in lines) {
        List<TextElement> elements = line.elements;

        for (TextElement element in elements) {
          textElements.add(element);
        }
      }
    }

    return textElements;
  }

  // facilitate sorting of the list in order of leftmost and topmost
  // elements
  double _compareBoxes(TextElement e1, TextElement e2) {
    double diffOfTops = e1.boundingBox.top - e2.boundingBox.top;
    double diffOfLeft = e1.boundingBox.left - e2.boundingBox.left;

    double height = (e1.boundingBox.height + e2.boundingBox.height) / 2;
    double verticalDiff = height * 0.35;

    double result = diffOfLeft;
    if (diffOfTops.abs() > verticalDiff) result = diffOfTops;

    return result;
  }

  void _swap(List<TextElement> list, int i, int j) {
    final temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  int _partition(List<TextElement> list, int low, int high) {
    TextElement pivot = list[high];

    int i = low - 1;
    for (int j = low; j <= high - 1; j++) {
      if (_compareBoxes(pivot, list[j]) > 0) {
        i++;
        _swap(list, i, j);
      }
    }
    _swap(list, i+1, high);

    return (i + 1);
  }

  void _sortElements(List<TextElement> list, int low, int high) {
    if (low < high) {
      int pi = _partition(list, low, high);
      _sortElements(list, low, pi-1);
      _sortElements(list, pi+1, high);
    }
  }

  // checks if two elements are on the same line with some skew allowed
  bool _isSameLine(TextElement e1, TextElement e2) {
    double diffOfTops = e1.boundingBox.top - e2.boundingBox.top;
    double height = (e1.boundingBox.height + e2.boundingBox.height) * 0.35;

    if (diffOfTops.abs() > height) {
      return false;
    }
    return true;
  }
}
