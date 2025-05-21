// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/logic/chart_logic.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/logic/traffic_logic.dart';

mixin TrafficHandlers<T extends StatefulWidget> on State<T> {
  // UI state
  String? selectedType;
  String? selectedDate;
  String? selectedTime;
  String? selectedYear;
  String? selectedSeason;

  String? generatedUrl;
  String? barChartUrl;
  bool isLoading = false;

  Map<String, dynamic> locationSnapshot = {}; // ✅ Fixed type
  Map<String, dynamic>? barChartData;

  bool get hasRequiredFilters =>
      selectedType != null && selectedDate != null && selectedTime != null;

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
    });
  }

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

  Future<void> handleGenerate({
    required String type,
    required String date,
    required String time,
    String? year,
    String? season,
  }) async {
    print('🚀 Generating heatmap and charts...');
    setState(() {
      isLoading = true;
      selectedType = type;
      selectedDate = date;
      selectedTime = time;
      selectedYear = year;
      selectedSeason = season;
    });

    try {
      final formattedTime = time.contains(':00:00') ? time : '$time:00';

      final url = await TrafficLogic.generateHeatmap(date, formattedTime, type);
      final snapshotList =
          await TrafficLogic.fetchSnapshot(date, formattedTime, type);
      final summaryData =
          await TrafficLogic.fetchSummaryStats(date, formattedTime, type);

      final barUrl = ChartLogic.generateBarChartUrl(
        date: date,
        time: formattedTime,
        trafficType: type,
      );

      // ✅ Convert List to Map using 'location' as key
      final snapshotMap = {
        for (var item in snapshotList) item['location']: item,
      };

      await Future.delayed(
          const Duration(seconds: 1)); // Give server time to finish

      setState(() {
        generatedUrl =
            "$url?t=${DateTime.now().millisecondsSinceEpoch}"; // force reload
        locationSnapshot = Map<String, dynamic>.from(snapshotMap);
        barChartData = summaryData['bar_chart'].cast<String, dynamic>();
        barChartUrl = barUrl;
      });
    } catch (e) {
      print('🔥 Error in handleGenerate: $e');
    }

    setState(() => isLoading = false);
  }
}
