// ====================================================
// Heatmap Card
// ----------------------------------------------------
// - Wraps HeatmapView with styled container
// - Logs the received heatmap URL
// - Adds border and rounded corners
// ====================================================

import 'package:flutter/material.dart';
import 'heatmap_view.dart';

class HeatmapCard extends StatelessWidget {
  final String url;

  const HeatmapCard({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    print("[HeatmapCard] received URL: $url");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: HeatmapView(heatmapUrl: url),
    );
  }
}
