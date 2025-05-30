import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/tools/weather_chart/weather_view.dart';

class WeatherChartCard extends StatelessWidget {
  final String? url;

  const WeatherChartCard({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const Center(child: Text('No weather chart available.'));
    }

    print("[WeatherChartCard] received URL: $url");
    return WeatherChartView(url: url!);
  }
}
