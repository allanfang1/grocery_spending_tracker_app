import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceiptScan extends StatefulWidget {
  @override
  State<ReceiptScan> createState() => _ReceiptScanState();
}

class _ReceiptScanState extends State<ReceiptScan> {
  bool _isPermissionGranted = false;

  late final Future<void> _future;

  @override
  void initState() {
    super.initState();

    _future = _requestCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Receipt Scanning Camera Permissions'),
          ),
          body: Center(
            child: Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Text(
                _isPermissionGranted
                    ? 'Camera permission granted'
                    : 'Camera permission denied',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }
}