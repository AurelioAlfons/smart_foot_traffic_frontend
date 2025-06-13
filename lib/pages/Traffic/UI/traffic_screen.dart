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
  // 0 = heatmap, 1 = dashboard
  int currentPage = 0;
  // Delcare zone for navbar hover effect
  bool hoveringNavZone = false;
  String? searchQuery;

  final GlobalKey<DashboardPanelState> dashboardKey =
      GlobalKey<DashboardPanelState>();

  @override
  Widget build(BuildContext context) {
    // Scaffold - paper for the Traffic Screen
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // Adaptive screen size
      body: LayoutBuilder(
        builder: (context, constraints) {
          // If screen is more then 800px wide -> Wide
          // Change this to adjust the screen size
          final isWide = constraints.maxWidth >= 800;

          // Declare the sidebar with all the filters and options
          final sidebar = TrafficSidebar(
            // Will log which location is selected on the list tab
            onLocationTap: (locationName) =>
                print('Selected location: $locationName'),
            // The generate & reset buttons
            onGenerate: handleGenerate,
            onReset: handleReset,
            // Filters
            selectedTrafficType: selectedType,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            selectedYear: selectedYear,
            selectedSeason: selectedSeason,
            // State variables
            isGenerated: generatedUrl != null,
            onTrafficTypeChanged: handleTrafficTypeChange,
            onTimeChanged: handleTimeChange,
            onDateChanged: (date) => setState(() => selectedDate = date),
            // Snapshot data for the sidebar
            snapshotData: locationSnapshot,
            // Search functionality
            searchQuery: searchQuery,
            onSearchChanged: (value) => setState(() => searchQuery = value),
          );

          // Stack the heatmap
          final heatmapStack = Stack(
            children: [
              // Heatmap card with generated URL or default
              // Call the heatmap card widget
              HeatmapCard(url: generatedUrl ?? defaultUrl),
              // If the heatmap is loading, show a loading bar
              if (isLoading)
                Align(
                  // And make it center at the top
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 14,
                    width: double.infinity,
                    // Loading bar
                    child: LinearProgressIndicator(
                      color: Colors.yellow[700],
                      backgroundColor: Colors.black26,
                    ),
                  ),
                )
            ],
          );

          // This is the size for full screen in laptop or monitor
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
                        // Fill the space - stretch
                        Expanded(
                          // IndexedStack = 1 page that can be switched
                          // Used to switch between heatmap and dashboard
                          child: IndexedStack(
                            // Call the current page
                            // In this 0 page is heatmap, 1 is dashboard
                            index: currentPage,
                            children: [
                              // Call the heatmap stack from above
                              // For the heatmap view
                              heatmapStack,
                              // If the filters are not empty
                              // Then fill the dashboard panel
                              // With the URLs and selected data
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
                                      forecastChartUrl: forecastChartUrl,
                                      // The placeholder is false now, not needed
                                      isPlaceholder: false,
                                      isLoading: isLoading,
                                      lineChartReady: lineChartReady,
                                      onResetLineChart: () => dashboardKey
                                          .currentState
                                          ?.resetLineChart(),
                                    )
                                  // If the date, time and type are not null
                                  // Show a placeholder
                                  : const DashboardPanel(isPlaceholder: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Navigation bar at the top
                    Align(
                      alignment: Alignment.topCenter,
                      // Plcaement the navigation bar
                      child: Transform.translate(
                        offset: const Offset(200, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32),
                          // MouseRegion for hover effect
                          child: MouseRegion(
                            onEnter: (_) =>
                                setState(() => hoveringNavZone = true),
                            onExit: (_) =>
                                setState(() => hoveringNavZone = false),
                            // Create a container for the navigation bar
                            child: SizedBox(
                              height: 64,
                              width: 360,
                              // If mouse is not hovering on this navbar
                              // Then can be ignored, mouse stays on stack
                              child: IgnorePointer(
                                ignoring: !hoveringNavZone,
                                // PointerInterceptor to capture mouse events
                                child: PointerInterceptor(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    // Color and border radius
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    // Center
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      // Inside that container
                                      // Buttons to switch
                                      // And the title of the page
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
                                        // Spacing
                                        const SizedBox(width: 12),
                                        // Title
                                        Text(
                                          // 0 = heatmap if not then dashboard
                                          currentPage == 0
                                              ? "Heatmap"
                                              : "Dashboard",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                        // Spacing
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
              // Mobile screen Layout
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey[900],
                      width: double.infinity,
                      // Contains the sidebar
                      child: sidebar,
                    ),
                    // Heatmap and Dashboard
                    Expanded(child: heatmapStack),
                  ],
                );
        },
      ),
    );
  }
}
