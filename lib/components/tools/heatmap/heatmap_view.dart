// heatmap_view.dart
// ======================
// - Displays the heatmap HTML using iframe
// - Supports loading state with LinearProgressIndicator

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

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
    // Register view type for iframe
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      heatmapUrl,
      (int viewId) => html.IFrameElement()
        ..src = heatmapUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true,
    );

    return Stack(
      children: [
        HtmlElementView(viewType: heatmapUrl),
        if (isLoading)
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(
                color: Colors.yellow,
                backgroundColor: Colors.black26,
              ),
            ),
          ),
      ],
    );
  }
}
