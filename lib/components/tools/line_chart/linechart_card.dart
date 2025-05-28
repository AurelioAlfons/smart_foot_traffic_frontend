import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/tools/line_chart/linechart_view.dart';

class LineChartCard extends StatelessWidget {
  final String url;

  const LineChartCard({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    print("[LineChartCard] received URL: $url");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LineChartView(url: url),
    );
  }
}
