import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'result_screen.dart';

/// Full-screen camera preview + QR/barcode scanning.
///
/// Camera permission is handled by mobile_scanner's own built-in flow (it
/// requests CAMERA at runtime and surfaces failures via [errorBuilder]) — no
/// separate permission_handler wiring is needed.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  // Guards against onDetect firing more than once while navigation to the
  // result screen is in flight (mobile_scanner can emit a couple of frames
  // in quick succession before scanning is actually stopped).
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    _handled = true;
    await _controller.stop();

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResultScreen(rawValue: rawValue)),
    );

    // Back from the result screen ("Scan again") — resume scanning.
    _handled = false;
    if (mounted) {
      await _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('SimiusQR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
        errorBuilder: (context, error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Camera error: ${error.errorDetails?.message ?? error.errorCode}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        overlayBuilder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _ReticlePainter(),
          );
        },
      ),
    );
  }
}

/// Simple square reticle centered on the preview to hint where to place the
/// QR code.
class _ReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double side = size.shortestSide * 0.6;
    final Rect reticle = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: side,
      height: side,
    );

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(reticle, const Radius.circular(16)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
