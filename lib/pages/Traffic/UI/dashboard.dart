import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/tools/bar_chart/barchart_card.dart';
import 'package:smart_foot_traffic_frontend/components/tools/line_chart/linechart_card.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/logic/chart_logic.dart';

class DashboardPanel extends StatefulWidget {
  final String? date;
  final String? time;
  final String? trafficType;
  final String? barChartUrl;
  final bool isPlaceholder;
  final bool isLoading;
  final bool lineChartReady;

  const DashboardPanel({
    super.key,
    this.date,
    this.time,
    this.trafficType,
    this.barChartUrl,
    this.isPlaceholder = false,
    this.isLoading = false,
    this.lineChartReady = false,
  });

  @override
  State<DashboardPanel> createState() => _DashboardPanelState();
}

class _DashboardPanelState extends State<DashboardPanel> {
  String? lastLineChartUrl;

  @override
  void didUpdateWidget(covariant DashboardPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentUrl = (widget.date != null && widget.trafficType != null)
        ? ChartLogic.generateLineChartUrl(
            date: widget.date!, trafficType: widget.trafficType!)
        : null;

    if (!widget.lineChartReady) {
      lastLineChartUrl = null;
    } else if (currentUrl != null) {
      lastLineChartUrl = currentUrl;
    }
  }

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

  Widget _chartWithLoader(Widget? child) {
    return Stack(
      children: [
        if (child != null) Positioned.fill(child: child),
        if (widget.isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.white70,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLaptop = screenWidth < 1380;

    final lineChartWidget =
        lastLineChartUrl != null ? LineChartCard(url: lastLineChartUrl!) : null;

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
                            : _chartWithLoader(
                                BarChartCard(chartUrl: widget.barChartUrl!),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 550,
                      child: _buildChartBox(
                        "Line Chart",
                        lineChartWidget == null
                            ? null
                            : _chartWithLoader(lineChartWidget),
                      ),
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
                          : _chartWithLoader(
                              BarChartCard(chartUrl: widget.barChartUrl!),
                            ),
                    ),
                    _buildChartBox(
                      "Line Chart",
                      lineChartWidget == null
                          ? null
                          : _chartWithLoader(lineChartWidget),
                    ),
                    _buildChartBox("Pie Chart", null),
                    _buildChartBox("Insights / Stats", null),
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
