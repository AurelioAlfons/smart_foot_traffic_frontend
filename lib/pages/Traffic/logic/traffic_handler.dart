// ====================================================
// Traffic Handlers
// ----------------------------------------------------
// - Handles filter changes and heatmap/chart generation
// - Stores selected filters, loading state, and snapshots
// - Calls backend logic to fetch heatmap and summary data
// ====================================================

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_foot_traffic_frontend/pages/Traffic/logic/chart_logic.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/logic/traffic_logic.dart';

mixin TrafficHandlers<T extends StatefulWidget> on State<T> {
  // ==============================
  // UI State Variables
  // ==============================
  String? selectedType;
  String? selectedDate;
  String? selectedTime;
  String? selectedYear;
  String? selectedSeason;

  String? generatedUrl;
  String? barChartUrl;
  String? pieChartUrl;
  String? forecastChartUrl;
  bool isLoading = false;
  bool lineChartReady = false;

  bool userTriggeredGenerate = false;

  Map<String, dynamic> locationSnapshot = {};
  Map<String, dynamic>? barChartData;

  VoidCallback? onResetLineChart;

  // ==============================
  // Helper Getters
  // ==============================
  bool get hasRequiredFilters =>
      selectedType != null && selectedDate != null && selectedTime != null;

  bool get isAutoRefreshable => userTriggeredGenerate && hasRequiredFilters;

  // ==============================
  // Reset All State
  // ==============================
  void handleReset() {
    setState(() {
      generatedUrl = null;
      barChartUrl = null;
      pieChartUrl = null;
      forecastChartUrl = null;
      selectedType = null;
      selectedDate = null;
      selectedTime = null;
      selectedYear = null;
      selectedSeason = null;
      locationSnapshot = {};
      barChartData = null;
      lineChartReady = false;
      userTriggeredGenerate = false;
    });

    onResetLineChart?.call();
  }

  // ==============================
  // Filter Handlers (auto-refresh only on time/type)
  // ==============================
  void handleTrafficTypeChange(String? type) {
    setState(() => selectedType = type);
    if (isAutoRefreshable) {
      handleGenerate(
        type: type!,
        date: selectedDate!,
        time: selectedTime!,
        year: selectedYear,
        season: selectedSeason,
      );
    }
  }

  void handleTimeChange(String? time) {
    setState(() => selectedTime = time);
    if (isAutoRefreshable) {
      handleGenerate(
        type: selectedType!,
        date: selectedDate!,
        time: time!,
        year: selectedYear,
        season: selectedSeason,
      );
    }
  }

  void handleDateChange(String? date) {
    setState(() => selectedDate = date);
  }

  void handleYearChange(String? year) {
    setState(() => selectedYear = year);
  }

  void handleSeasonChange(String? season) {
    setState(() => selectedSeason = season);
  }

  // ==============================
  // Main Generate Handler
  // ==============================
  Future<void> handleGenerate({
    required String type,
    required String date,
    required String time,
    String? year,
    String? season,
  }) async {
    print('Generating heatmap and charts...');
    setState(() {
      isLoading = true;
      lineChartReady = false;
      userTriggeredGenerate = true;
      selectedType = type;
      selectedDate = date;
      selectedTime = time;
      selectedYear = year;
      selectedSeason = season;
    });

    try {
      final formattedTime = time.contains(':00:00') ? time : '$time:00';

      final barUrl = ChartLogic.generateBarChartUrl(
        date: date,
        time: formattedTime,
        trafficType: type,
      );
      final pieUrl = ChartLogic.generatePieChartUrl(date: date);
      final forecastUrl =
          ChartLogic.generateForecastChartUrl(trafficType: type);

      // Step 1: Run all async tasks in parallel
      final results = await Future.wait([
        TrafficLogic.generateLineChart(date, type), // [0]
        TrafficLogic.generateHeatmap(date, formattedTime, type), // [1]
        TrafficLogic.fetchSnapshot(date, formattedTime, type), // [2]
        TrafficLogic.fetchSummaryStats(date, formattedTime, type), // [3]
        TrafficLogic.generatePieChart(date), // [4]
        TrafficLogic.generateForecastChart(type), // [5]
      ]);

      final heatmapUrl = results[1] as String;
      final snapshotList = results[2] as List;
      final summaryData = results[3] as Map<String, dynamic>;

      final snapshotMap = {
        for (var item in snapshotList) item['location']: item,
      };

      // Step 2: Confirm HTMLs are ready
      final heatmapReady = await _pingUrl(heatmapUrl);
      final pieReady = await _pingUrl(pieUrl);
      final forecastReady = await _pingUrl(forecastUrl);

      if (heatmapReady) {
        setState(() {
          generatedUrl =
              "$heatmapUrl?t=${DateTime.now().millisecondsSinceEpoch}";
          locationSnapshot = Map<String, dynamic>.from(snapshotMap);
          barChartData = summaryData['bar_chart'].cast<String, dynamic>();
          barChartUrl = barUrl;
          pieChartUrl = pieReady
              ? "$pieUrl?t=${DateTime.now().millisecondsSinceEpoch}"
              : null;
          forecastChartUrl = forecastReady
              ? "$forecastUrl?t=${DateTime.now().millisecondsSinceEpoch}"
              : null;
          lineChartReady = true;
        });
      } else {
        print("[Heatmap] HTML not ready.");
      }
    } catch (e) {
      print('Error in handleGenerate: $e');
    }

    setState(() => isLoading = false);
  }

  // ==============================
  // Ping URL (for heatmap, pie, forecast)
  // ==============================
  Future<bool> _pingUrl(String url) async {
    try {
      final response =
          await http.head(Uri.parse(url)).timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
