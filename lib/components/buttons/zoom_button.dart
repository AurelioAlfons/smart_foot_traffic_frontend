import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ZoomButton extends StatelessWidget {
  final String? url;

  const ZoomButton({super.key, required this.url});

  // This method opens the provided URL in a new tab.
  // If the URL is null or empty, it prints a message to the console.
  void _openInNewTab() {
    if (url != null && url!.isNotEmpty) {
      html.window.open(url!, '_blank');
    } else {
      // ignore: avoid_print
      print("No URL available to open!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      // Button to open the URL in a new tab
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 18, 18),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
        onPressed: _openInNewTab,
        child: const Text("Zoom 🔍"),
      ),
    );
  }
}
