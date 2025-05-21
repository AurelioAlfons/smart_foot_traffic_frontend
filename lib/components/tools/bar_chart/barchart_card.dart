import 'package:flutter/material.dart';
import 'barchart_view.dart';

class BarChartCard extends StatelessWidget {
  final String? chartUrl;

  const BarChartCard({super.key, required this.chartUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 460,
        child: chartUrl == null
            ? const Center(child: Text('No bar chart available.'))
            : Padding(
                padding: const EdgeInsets.all(12),
                child: BarChartView(url: chartUrl!),
              ),
      ),
    );
  }
}
