// ====================================================
// Forecast Chart Card
// ----------------------------------------------------
// - Shows forecast chart using provided URL
// - Displays fallback text if no URL is given
// - Embeds ForecastChartView with full width/height
// ====================================================

import 'package:flutter/material.dart';
import 'forecast_view.dart';

class ForecastCard extends StatelessWidget {
  final String? chartUrl;

  const ForecastCard({super.key, required this.chartUrl});

  @override
  Widget build(BuildContext context) {
    return chartUrl == null
        ? const Center(child: Text('No forecast chart available.'))
        : ForecastChartView(url: chartUrl!);
  }
}
