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
    final screenWidth = MediaQuery.of(context).size.width;
    final isLaptop = screenWidth < 1380;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: isLaptop
              // Laptop: stacked full-width scrollable layout
              ? ListView(
                  children: [
                    SizedBox(
                      height: 550,
                      child: _buildChartBox(
                        "Bar Chart",
                        (isPlaceholder || barChartUrl == null)
                            ? null
                            : BarChartCard(chartUrl: barChartUrl!),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 550,
                      child: _buildChartBox("Line Chart", null),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 550,
                      child: _buildChartBox("Pie Chart", null),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 550,
                      child: _buildChartBox("Insights / Stats", null),
                    ),
                  ],
                )

              // Monitor: 2x2 grid layout
              : GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildChartBox(
                      "Bar Chart",
                      (isPlaceholder || barChartUrl == null)
                          ? null
                          : BarChartCard(chartUrl: barChartUrl!),
                    ),
                    _buildChartBox("Line Chart", null),
                    _buildChartBox("Pie Chart", null),
                    _buildChartBox("Insights / Stats", null),
                  ],
                ),
        ),

        // Progress Bar
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
          ),
      ],
    );
  }
}
