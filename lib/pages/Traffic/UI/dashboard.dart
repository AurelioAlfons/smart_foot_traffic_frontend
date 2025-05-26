import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/tools/bar_chart/barchart_card.dart';

class DashboardPanel extends StatelessWidget {
  final String? date;
  final String? time;
  final String? trafficType;
  final String? barChartUrl;
  final bool isPlaceholder;
  final bool isLoading;

  const DashboardPanel({
    super.key,
    this.date,
    this.time,
    this.trafficType,
    this.barChartUrl,
    this.isPlaceholder = false,
    this.isLoading = false,
  });

  Widget _buildChartBox(String title, Widget? child) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (child != null) Expanded(child: child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              // Box 1: Bar Chart
              _buildChartBox(
                "Bar Chart",
                (isPlaceholder || barChartUrl == null)
                    ? null
                    : BarChartCard(chartUrl: barChartUrl!),
              ),

              // Box 2: Line Chart
              _buildChartBox("Line Chart", null),

              // Box 3: Pie Chart
              _buildChartBox("Pie Chart", null),

              // Box 4: Insights
              _buildChartBox("Insights / Stats", null),
            ],
          ),
        ),

        // Yellow Progress Bar (bottom right)
        if (isLoading)
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 14,
              width: double.infinity,
              child: LinearProgressIndicator(
                color: Colors.yellow[700],
                backgroundColor: Colors.black26,
              ),
            ),
          )
      ],
    );
  }
}
