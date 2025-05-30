import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/tools/pie_chart/piechart_view.dart';

class PieChartCard extends StatelessWidget {
  final String? url;

  const PieChartCard({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const Center(child: Text('No pie chart available.'));
    }

    print("[PieChartCard] received URL: $url");
    return PieChartView(url: url!);
  }
}
