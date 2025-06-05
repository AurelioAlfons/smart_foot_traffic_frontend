// ===============================
// Dashboard Panel
// -------------------------------
// Shows bar, line, pie, and forecast charts
// Switches layout on small screens
// Handles loading and updates
// ===============================

import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/tools/bar_chart/barchart_card.dart';
import 'package:smart_foot_traffic_frontend/components/tools/forecast/forecast_card.dart';
import 'package:smart_foot_traffic_frontend/components/tools/line_chart/linechart_card.dart';
import 'package:smart_foot_traffic_frontend/components/tools/pie_chart/piechart_card.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/logic/chart_logic.dart';

class DashboardPanel extends StatefulWidget {
  final String? date;
  final String? time;
  final String? trafficType;
  final String? barChartUrl;
  final String? pieChartUrl;
  final String? forecastChartUrl;
  final bool isPlaceholder;
  final bool isLoading;
  final bool lineChartReady;
  final VoidCallback? onResetLineChart;

  const DashboardPanel({
    super.key,
    this.date,
    this.time,
    this.trafficType,
    this.barChartUrl,
    this.pieChartUrl,
    this.forecastChartUrl,
    this.isPlaceholder = false,
    this.isLoading = false,
    this.lineChartReady = false,
    this.onResetLineChart,
  });

  @override
  State<DashboardPanel> createState() => DashboardPanelState();
}

class DashboardPanelState extends State<DashboardPanel> {
  String? lastLineChartUrl;

  @override
  void didUpdateWidget(covariant DashboardPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentUrl = (widget.date != null && widget.trafficType != null)
        ? ChartLogic.generateLineChartUrl(
            date: widget.date!, trafficType: widget.trafficType!)
        : null;

    if (widget.lineChartReady && currentUrl != null) {
      setState(() {
        lastLineChartUrl = currentUrl;
      });
    }
  }

  void resetLineChart() {
    setState(() {
      lastLineChartUrl = null;
    });
  }

  Widget _buildChartBox(String title, Widget? child) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
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
          if (widget.isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.white70,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.yellow),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLaptop = screenWidth < 1380;

    final lineChartWidget =
        lastLineChartUrl != null ? LineChartCard(url: lastLineChartUrl!) : null;

    final pieChartWidget = widget.pieChartUrl != null
        ? PieChartCard(url: widget.pieChartUrl!)
        : null;

    final forecastWidget = widget.forecastChartUrl != null
        ? ForecastCard(chartUrl: widget.forecastChartUrl!)
        : null;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: isLaptop
              ? ListView(
                  children: [
                    SizedBox(
                      height: 550,
                      child: _buildChartBox(
                        "Bar Chart",
                        widget.barChartUrl == null
                            ? null
                            : BarChartCard(chartUrl: widget.barChartUrl!),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 550,
                      child: _buildChartBox(
                        "Line Chart",
                        Stack(
                          children: [
                            if (lineChartWidget != null) lineChartWidget,
                            if (widget.isLoading)
                              const Positioned.fill(
                                child: ColoredBox(
                                  color: Colors.white70,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.yellow),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 550,
                      child: _buildChartBox("Pie Chart", pieChartWidget),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 550,
                      child: _buildChartBox("Forecast Chart", forecastWidget),
                    ),
                  ],
                )
              : GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildChartBox(
                      "Bar Chart",
                      (widget.isPlaceholder || widget.barChartUrl == null)
                          ? null
                          : BarChartCard(chartUrl: widget.barChartUrl!),
                    ),
                    _buildChartBox(
                      "Line Chart",
                      lineChartWidget,
                    ),
                    _buildChartBox("Pie Chart", pieChartWidget),
                    _buildChartBox("Forecast Chart", forecastWidget),
                  ],
                ),
        ),
        if (widget.isLoading)
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
