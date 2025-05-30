// ====================================================
// Traffic Sidebar Panel
// ----------------------------------------------------
// - Has location list and filter tabs
// - Lets users search, filter, and generate heatmaps
// - Handles year/season dropdown, reset, and login
// ====================================================

import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/buttons/hover.dart';
import 'package:smart_foot_traffic_frontend/components/buttons/search.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/widgets/filter/filter_tab.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/widgets/location/location_tab.dart';

class TrafficSidebar extends StatefulWidget {
  final void Function(String locationName)? onLocationTap;
  final Future<void> Function({
    required String date,
    required String time,
    required String type,
    String? year,
    String? season,
  }) onGenerate;
  final VoidCallback onReset;
  final String? selectedTrafficType;
  final String? selectedDate;
  final String? selectedTime;
  final String? selectedYear;
  final String? selectedSeason;
  final bool isGenerated;
  final void Function(String?) onTrafficTypeChanged;
  final void Function(String?) onTimeChanged;
  final void Function(String?) onDateChanged;
  final Map<String, dynamic>? snapshotData;

  final String? searchQuery;
  final void Function(String)? onSearchChanged;

  const TrafficSidebar({
    super.key,
    this.onLocationTap,
    required this.onGenerate,
    required this.onReset,
    this.selectedTrafficType,
    this.selectedDate,
    this.selectedTime,
    this.selectedYear,
    this.selectedSeason,
    required this.isGenerated,
    required this.onTrafficTypeChanged,
    required this.onTimeChanged,
    required this.onDateChanged,
    this.snapshotData,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  State<TrafficSidebar> createState() => _TrafficSidebarState();
}

class _TrafficSidebarState extends State<TrafficSidebar> {
  String? selectedYear = "Year";
  String? selectedSeason = "Season";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Menu button with hover effect
                  HoverableIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                  const SizedBox(width: 6),
                  // Title
                  const Text(
                    "Footscray Traffic",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                hoverColor: Colors.transparent,
                child: Row(
                  children: [
                    // Login - To be implemented
                    HoverableIconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search bar for location search
          LocationSearchBar(
            query: widget.searchQuery,
            onChanged: widget.onSearchChanged!,
          ),
          const SizedBox(height: 12),
          Theme(
  data: Theme.of(context).copyWith(
    tabBarTheme: TabBarThemeData(
      labelColor: Colors.yellow[700],
      unselectedLabelColor: Colors.white70,
    ),
  ),


            // Tab - List & Filters
            child: TabBar(
              indicatorColor: Colors.yellow[700],
              tabs: const [
                // List
                Tab(
                  child: Text(
                    'List',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                // Filters
                Tab(
                  child: Text(
                    'Filters',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Location List Tab
                LocationTab(
                  snapshotData: widget.snapshotData,
                  onLocationTap: widget.onLocationTap,
                  searchQuery: widget.searchQuery,
                ),
                // Filters Tab
                _buildFiltersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the Filters tab with all filter options
  Widget _buildFiltersTab() {
    return FilterTab(
      selectedType: widget.selectedTrafficType,
      selectedDate: widget.selectedDate,
      selectedTime: widget.selectedTime,
      selectedYear: selectedYear,
      selectedSeason: selectedSeason,
      onTypeChanged: widget.onTrafficTypeChanged,
      onDateChanged: widget.onDateChanged,
      onTimeChanged: widget.onTimeChanged,
      onYearChanged: (value) {
        setState(() {
          selectedYear = value;
        });
      },
      onSeasonChanged: (value) {
        setState(() {
          selectedSeason = value;
        });
      },
      onGenerate: () {
        if (widget.selectedDate != null &&
            widget.selectedTime != null &&
            widget.selectedTrafficType != null) {
          widget.onGenerate(
            date: widget.selectedDate!,
            time: widget.selectedTime!,
            type: widget.selectedTrafficType!,
            year: selectedYear,
            season: selectedSeason,
          );
        }
      },
      onReset: () {
        widget.onReset();
        setState(() {
          selectedYear = "Year";
          selectedSeason = "Season";
        });
      },
    );
  }
}
