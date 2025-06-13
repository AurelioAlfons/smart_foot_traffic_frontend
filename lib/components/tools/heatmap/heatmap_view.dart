// ====================================================
// Heatmap View (Web Only)
// ----------------------------------------------------
// - Shows heatmap HTML in an iframe
// - Registers unique view ID using hash of the URL
// - Displays loading bar if isLoading is true
// ====================================================

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

// Correct import for web-only platformViewRegistry
import 'dart:ui_web' as ui;

class HeatmapView extends StatelessWidget {
  final String heatmapUrl;
  final bool isLoading;

  const HeatmapView({
    super.key,
    required this.heatmapUrl,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final viewType = 'heatmap-${heatmapUrl.hashCode}';
    print("📡 iframe loading: $heatmapUrl");

    // To register HTML iframe
    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(
        viewType,
        (int viewId) => html.IFrameElement()
          ..src = heatmapUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allowFullscreen = true,
      );
    }

    return Stack(
      children: [
        HtmlElementView(viewType: viewType),
        if (isLoading)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              // Spinner
              child: LinearProgressIndicator(
                color: Colors.yellow[700],
                backgroundColor: Colors.black26,
              ),
            ),
          ),
      ],
    );
  }
}

//git config --global user.name "Adham Soliman"
//git config --global user.email "adham.jsg@gmail.com"
