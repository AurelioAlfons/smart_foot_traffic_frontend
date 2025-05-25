// ====================================================
// Bar Chart Card
// ----------------------------------------------------
// - Shows bar chart using provided URL
// - Displays fallback text if no URL is given
// - Embeds BarChartView with full width/height
// ====================================================

import 'package:flutter/material.dart';
import 'barchart_view.dart';

class BarChartCard extends StatelessWidget {
  final String? chartUrl;

  const BarChartCard({super.key, required this.chartUrl});

  @override
  Widget build(BuildContext context) {
    return chartUrl == null
        ? const Center(child: Text('No bar chart available.'))
        : BarChartView(url: chartUrl!);
  }
}
