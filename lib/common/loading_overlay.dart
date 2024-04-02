import 'package:flutter/material.dart';

// This class creates a reusable loading overlay. It takes a page (Widget) as input.
class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  static _LoadingOverlayState of(BuildContext context) {
    return context.findAncestorStateOfType<_LoadingOverlayState>()!;
  }

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

// Stores the state and functionality of the loading overlay
class _LoadingOverlayState extends State<LoadingOverlay> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Builds the UI for the loading overlay
    return Stack(children: [
      widget.child,
      if (_isLoading)
        const Opacity(
            opacity: 0.6,
            child: ModalBarrier(dismissible: false, color: Colors.black)),
      if (_isLoading)
        const Center(child: CircularProgressIndicator()),
    ]);
  }

  // Set loading overlay to be visible
  void show() {
    setState(() {
      _isLoading = true;
    });
  }

  // Hide loading overlay
  void hide() {
    setState(() {
      _isLoading = false;
    });
  }
}
