// ====================================================
// Traffic Screen UI
// ----------------------------------------------------
// - Displays sidebar filters and heatmap/dashboard view
// - Toggles between heatmap and summary panel
// - Loads heatmap with progress indicator and user filters
// ====================================================

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:smart_foot_traffic_frontend/components/buttons/hover.dart';
import 'package:smart_foot_traffic_frontend/components/tools/heatmap/heatmap.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/UI/dashboard.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/UI/traffic_sidebar.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/logic/traffic_handler.dart';

class TrafficScreen extends StatefulWidget {
  const TrafficScreen({super.key});

  @override
  State<TrafficScreen> createState() => TrafficScreenState();
}

class TrafficScreenState extends State<TrafficScreen> with TrafficHandlers {
  // URLs for default heatmap
  final String defaultUrl = 'http://localhost:5000/heatmaps/default_map.html';
  // For navigation between heatmap and dashboard
  int currentPage = 0;
  // Delcare zone for navbar hover effect
  bool hoveringNavZone = false;
  String? searchQuery;

  final GlobalKey<DashboardPanelState> dashboardKey =
      GlobalKey<DashboardPanelState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: LayoutBuilder(
        builder: (context, constraints) {
          //
          final isWide = constraints.maxWidth >= 800;

          final sidebar = TrafficSidebar(
            onLocationTap: (locationName) =>
                print('Selected location: $locationName'),
            onGenerate: handleGenerate,
            onReset: handleReset,
            selectedTrafficType: selectedType,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            selectedYear: selectedYear,
            selectedSeason: selectedSeason,
            isGenerated: generatedUrl != null,
            onTrafficTypeChanged: handleTrafficTypeChange,
            onTimeChanged: handleTimeChange,
            onDateChanged: (date) => setState(() => selectedDate = date),
            snapshotData: locationSnapshot,
            searchQuery: searchQuery,
            onSearchChanged: (value) => setState(() => searchQuery = value),
          );

          // Stack the heatmap
          final heatmapStack = Stack(
            children: [
              // Heatmap card with generated URL or default
              HeatmapCard(url: generatedUrl ?? defaultUrl),
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

          //
          return isWide
              ? Stack(
                  children: [
                    Row(
                      children: [
                        Container(
                          width:
                              (constraints.maxWidth * 0.28).clamp(300.0, 340.0),
                          padding: const EdgeInsets.all(12),
                          color: Colors.grey[900],
                          child: sidebar,
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: currentPage,
                            children: [
                              heatmapStack,
                              (selectedDate != null &&
                                      selectedTime != null &&
                                      selectedType != null)
                                  ? DashboardPanel(
                                      key: dashboardKey,
                                      date: selectedDate!,
                                      time: selectedTime!,
                                      trafficType: selectedType!,
                                      barChartUrl: barChartUrl,
                                      pieChartUrl: pieChartUrl,
                                      weatherChartUrl: weatherChartUrl,
                                      isPlaceholder: false,
                                      isLoading: isLoading,
                                      lineChartReady: lineChartReady,
                                      onResetLineChart: () => dashboardKey
                                          .currentState
                                          ?.resetLineChart(),
                                    )
                                  : const DashboardPanel(isPlaceholder: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Transform.translate(
                        offset: const Offset(200, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: MouseRegion(
                            onEnter: (_) =>
                                setState(() => hoveringNavZone = true),
                            onExit: (_) =>
                                setState(() => hoveringNavZone = false),
                            child: SizedBox(
                              height: 64,
                              width: 360,
                              child: IgnorePointer(
                                ignoring: !hoveringNavZone,
                                child: PointerInterceptor(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Left -> Go to Dashboard
                                        HoverableIconButton(
                                          onPressed: () {
                                            setState(() => currentPage =
                                                (currentPage - 1 + 2) % 2);
                                          },
                                          icon: const Icon(Icons.chevron_left,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(width: 12),
                                        // Title
                                        Text(
                                          currentPage == 0
                                              ? "Heatmap"
                                              : "Dashboard",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Right -> Go to Heatmap
                                        HoverableIconButton(
                                          onPressed: () {
                                            setState(() => currentPage =
                                                (currentPage + 1) % 2);
                                          },
                                          icon: const Icon(Icons.chevron_right,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey[900],
                      width: double.infinity,
                      child: sidebar,
                    ),
                    Expanded(child: heatmapStack),
                  ],
                );
        },
      ),
    );
  }
}
