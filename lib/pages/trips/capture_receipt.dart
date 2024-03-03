import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/pages/trips/confirm_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/format_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/parse_receipt.dart';
import 'package:grocery_spending_tracker_app/controller/extract_data.dart';
import 'package:grocery_spending_tracker_app/model/grocery_trip.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

class CaptureReceipt extends StatefulWidget {
  const CaptureReceipt({Key? key}) : super(key: key);

  @override
  State<CaptureReceipt> createState() => _CaptureReceiptState();
}

class _CaptureReceiptState extends State<CaptureReceipt>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  bool _showFocusCircle = false;
  late final Future<void> _future;
  CameraController? _cameraController;
  double _x = 0;
  double _y = 0;

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
            _isPermissionGranted
                ? FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _initCameraController(snapshot.data!);

                        return GestureDetector(
                            onTapUp: (details) {
                              _onTap(details);
                            },
                            child: Stack(
                              children: [
                                Center(
                                    child: Scaffold(
                                  appBar: AppBar(
                                    title: const Text(
                                        Constants.SCAN_RECEIPT_LABEL),
                                  ),
                                  body: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 90.0),
                                      child: Center(
                                          child: CameraPreview(
                                              _cameraController!))),
                                  floatingActionButton: FloatingActionButton(
                                    backgroundColor: Colors.white,
                                    onPressed: scanReceipt,
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                    ),
                                  ),
                                  floatingActionButtonLocation:
                                      FloatingActionButtonLocation.centerFloat,
                                  backgroundColor: Colors.black,
                                )),
                                if (_showFocusCircle)
                                  Positioned(
                                      top: _y - 20,
                                      left: _x - 20,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 1.5)),
                                      ))
                              ],
                            ));
                      } else {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text(Constants.SCAN_RECEIPT_LABEL),
                          ),
                          body: const Center(
                              child: Text('An error occurred with the camera')),
                        );
                      }
                    },
                  )
                : Scaffold(
                    appBar: AppBar(
                      title: const Text(Constants.SCAN_RECEIPT_LABEL),
                    ),
                    body: const Center(
                        child: Text('Camera permission not granted')),
                  ),
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

  Future<void> _onTap(TapUpDetails details) async {
    if (_cameraController!.value.isInitialized) {
      _showFocusCircle = true;
      _x = details.localPosition.dx;
      _y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * _cameraController!.value.aspectRatio;

      double xp = _x / fullWidth;
      double yp = _y / cameraHeight;

      Offset point = Offset(xp, yp);

      // Manually focus
      await _cameraController!.setFocusPoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            _showFocusCircle = false;
          });
        });
      });
    }
  }

  Future<void> scanReceipt() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);
    final loading = LoadingOverlay.of(context);
    final scaffold = ScaffoldMessenger.of(context);

    try {
      loading.show();

      _cameraController!.setFlashMode(FlashMode.off); // caused issues when on
      final receipt = await _cameraController!.takePicture();
      await _cameraController!.pausePreview();

      final scannedReceipt = await ParseReceipt().scanReceipt(receipt);

      final receiptToList = ExtractData().textToList(scannedReceipt);

      final GroceryTrip formattedReceipt =
          FormatReceipt().formatGroceryTrip(receiptToList);

      loading.hide();
      await _cameraController!.resumePreview();

      await navigator.push(MaterialPageRoute(
          builder: (context) => LoadingOverlay(
                child: ConfirmReceipt(tripData: formattedReceipt),
              )));
    } catch (e) {
      loading.hide();
      await _cameraController!.resumePreview();

      scaffold.showSnackBar(const SnackBar(
        content: Text('An error occurred scanning the receipt.'),
      ));
    }
  }
}
