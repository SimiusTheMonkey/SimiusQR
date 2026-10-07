import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'uri_utils.dart';

/// Shows the raw decoded QR payload and, when it's a URI with a scheme
/// (http/https/tel/mailto/sms/etc.), a button to open it via the OS handler.
/// No auto-redirect — the user always sees the destination before choosing
/// to open it.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.rawValue});

  final String rawValue;

  Future<void> _open(BuildContext context) async {
    final uri = Uri.tryParse(rawValue.trim());
    if (uri == null) return;

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No app found to open this link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final openable = isOpenableUri(rawValue);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                rawValue,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              if (openable) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _open(context),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open'),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan again'),
      ),
    );
  }
}
