import 'dart:io';

import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ParseReceipt {
  final _receiptScanner = TextRecognizer();

  Future<RecognizedText?> scanReceipt(
      CameraController? cameraController, XFile receipt) async {
    final file = File(receipt.path);
    final inputReceipt = InputImage.fromFile(file);
    final scannedReceipt = await _receiptScanner.processImage(inputReceipt);

    return scannedReceipt;
  }
}
