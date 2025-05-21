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

  Widget _buildChartBox(String title, Widget child) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderBox(String title) {
    return _buildChartBox(
      title,
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
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
          // 🔹 Box 1: Bar Chart
          (isPlaceholder || barChartUrl == null)
              ? _buildPlaceholderBox('Bar Chart (Loading...)')
              : _buildChartBox(
                  'Traffic by Location (Plotly)',
                  BarChartCard(chartUrl: barChartUrl!),
                ),

          // 🔹 Box 2: Line Chart
          isPlaceholder
              ? _buildPlaceholderBox('Line Chart (Loading...)')
              : _buildChartBox(
                  'Line Chart (Coming Soon)',
                  const Center(child: Text("Line chart placeholder")),
                ),

          // 🔹 Box 3: Pie Chart
          isPlaceholder
              ? _buildPlaceholderBox('Pie Chart (Loading...)')
              : _buildChartBox(
                  'Pie Chart (Coming Soon)',
                  const Center(child: Text("Pie chart placeholder")),
                ),

          // 🔹 Box 4: Insights
          isPlaceholder
              ? _buildPlaceholderBox('Insights (Loading...)')
              : _buildChartBox(
                  'Insights / Stats',
                  const Center(child: Text("Insights placeholder")),
                ),
        ],
      ),
    );
  }
}
