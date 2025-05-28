import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/tools/line_chart/linechart_view.dart';

class LineChartCard extends StatelessWidget {
  final String? url;

  const LineChartCard({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const Center(child: Text('No line chart available.'));
    }

    print("[LineChartCard] received URL: $url");
    return LineChartView(url: url!);
  }
}
