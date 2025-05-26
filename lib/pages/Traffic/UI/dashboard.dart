// ====================================================
// Dashboard Panel (Flat Style)
// ----------------------------------------------------
// - Displays 4 chart sections in a 2x2 grid
// - Flat container style (no curves/cards)
// - Supports placeholder mode and dynamic rendering
// ====================================================

import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/tools/bar_chart/barchart_card.dart';

class DashboardPanel extends StatelessWidget {
  final String? date;
  final String? time;
  final String? trafficType;
  final String? barChartUrl;
  final bool isPlaceholder;

  const DashboardPanel({
    super.key,
    this.date,
    this.time,
    this.trafficType,
    this.barChartUrl,
    this.isPlaceholder = false,
  });

  Widget _buildFlatBox(String? title, Widget child, {bool showTitle = true}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: showTitle
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(child: child),
              ],
            )
          : child,
    );
  }

  Widget _buildPlaceholderBox(String title) {
    return _buildFlatBox(
      title,
      Container(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          // Box 1: Bar Chart
          (isPlaceholder || barChartUrl == null)
              ? _buildFlatBox('Bar Chart', _buildPlaceholder(), showTitle: true)
              : _buildFlatBox(null, BarChartCard(chartUrl: barChartUrl!),
                  showTitle: false),

          // Box 2: Line Chart
          isPlaceholder
              ? _buildPlaceholderBox('Line Chart')
              : _buildFlatBox('Line Chart (Coming Soon)',
                  const Center(child: Text("Line chart placeholder"))),

          // Box 3: Pie Chart
          isPlaceholder
              ? _buildPlaceholderBox('Pie Chart')
              : _buildFlatBox('Pie Chart (Coming Soon)',
                  const Center(child: Text("Pie chart placeholder"))),

          // Box 4: Insights
          isPlaceholder
              ? _buildPlaceholderBox('Insights')
              : _buildFlatBox('Insights / Stats',
                  const Center(child: Text("Insights placeholder"))),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(color: Colors.white);
  }
}
