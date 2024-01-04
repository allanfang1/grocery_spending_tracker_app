import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/src/confirm_receipt.dart';
import 'package:grocery_spending_tracker_app/src/parse_receipt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

class CaptureReceipt extends StatefulWidget {
  @override
  State<CaptureReceipt> createState() => _CaptureReceiptState();
}

class _CaptureReceiptState extends State<CaptureReceipt>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  bool _isActive = true;
  late final Future<void> _future;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const Center(
                        child: Text('Camera permission not granted'));
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('Receipt Scanning'),
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: _isActive
                                    ? () {
                                        setState(() {
                                          _isActive = false;
                                        });
                                        _scanReceipt();
                                      }
                                    : null,
                                child: _isActive
                                    ? const Text('Scan Receipt')
                                    : Container(
                                        width: 24,
                                        height: 24,
                                        padding: const EdgeInsets.all(2.0),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 3,
                                        )),
                              ),
                            ))
                      ],
                    )
                  : Center(
                      child: Container(
                          padding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: const Text(
                            'Camera permission denied',
                            textAlign: TextAlign.center,
                          ))),
            )
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    // if the cameraController is already set
    if (_cameraController != null) return;

    // goal is to select the first rear camera
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController?.initialize();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _scanReceipt() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      _cameraController!.setFlashMode(FlashMode.off); // caused issues when on
      final receipt = await _cameraController!.takePicture();

      final scannedReceipt = await ParseReceipt().scanReceipt(receipt);

      // reset button for page returns
      setState(() {
        _isActive = true;
      });

      await navigator.push(MaterialPageRoute(
          builder: (context) =>
              ConfirmReceipt(receiptData: scannedReceipt!.text)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred scanning the receipt.'),
      ));
    }
  }
}
