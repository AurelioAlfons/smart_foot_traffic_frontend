// ====================================================
// Traffic Handlers
// ----------------------------------------------------
// - Handles filter changes and heatmap/chart generation
// - Stores selected filters, loading state, and snapshots
// - Calls backend logic to fetch heatmap and summary data
// ====================================================

// ignore_for_file: avoid_print
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
  bool isLoading = false;
  bool lineChartReady = false;

  Map<String, dynamic> locationSnapshot = {};
  Map<String, dynamic>? barChartData;

  /// Optional: Call this from parent widget to reset line chart URL, e.g., `lastLineChartUrl = null`
  VoidCallback? onResetLineChart;

  // ==============================
  // Helper Getters
  // ==============================
  bool get hasRequiredFilters =>
      selectedType != null && selectedDate != null && selectedTime != null;

  // ==============================
  // Reset All State
  // ==============================
  void handleReset() {
    setState(() {
      generatedUrl = null;
      barChartUrl = null;
      selectedType = null;
      selectedDate = null;
      selectedTime = null;
      selectedYear = null;
      selectedSeason = null;
      locationSnapshot = {};
      barChartData = null;
      lineChartReady = false;
    });

    // Reset line chart URL in parent if provided
    onResetLineChart?.call();
  }

  // ==============================
  // Filter Handlers
  // ==============================
  void handleTrafficTypeChange(String? type) {
    setState(() => selectedType = type);
    if (generatedUrl != null && hasRequiredFilters) {
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
    if (generatedUrl != null && hasRequiredFilters) {
      handleGenerate(
        type: selectedType!,
        date: selectedDate!,
        time: time!,
        year: selectedYear,
        season: selectedSeason,
      );
    }
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
      selectedType = type;
      selectedDate = date;
      selectedTime = time;
      selectedYear = year;
      selectedSeason = season;
    });

    try {
      final formattedTime = time.contains(':00:00') ? time : '$time:00';

      // Step 1: Generate Line Chart
      await TrafficLogic.generateLineChart(date, type);
      lineChartReady = true;

      // Step 2: Run parallel async tasks
      final results = await Future.wait([
        TrafficLogic.generateHeatmap(date, formattedTime, type),
        TrafficLogic.fetchSnapshot(date, formattedTime, type),
        TrafficLogic.fetchSummaryStats(date, formattedTime, type),
      ]);

      final url = results[0] as String;
      final snapshotList = results[1] as List;
      final summaryData = results[2] as Map<String, dynamic>;

      final barUrl = ChartLogic.generateBarChartUrl(
        date: date,
        time: formattedTime,
        trafficType: type,
      );

      final snapshotMap = {
        for (var item in snapshotList) item['location']: item,
      };

      // Step 3: Ping heatmap to make sure it’s ready
      final isReady = await _pingHeatmap(url);

      if (isReady) {
        setState(() {
          generatedUrl = "$url?t=${DateTime.now().millisecondsSinceEpoch}";
          locationSnapshot = Map<String, dynamic>.from(snapshotMap);
          barChartData = summaryData['bar_chart'].cast<String, dynamic>();
          barChartUrl = barUrl;
        });
      } else {
        print("Heatmap HTML not ready yet.");
      }
    } catch (e) {
      print('Error in handleGenerate: $e');
    }

    setState(() => isLoading = false);
  }

  // ==============================
  // Ping Heatmap URL
  // ==============================
  Future<bool> _pingHeatmap(String url) async {
    try {
      final response =
          await http.head(Uri.parse(url)).timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
