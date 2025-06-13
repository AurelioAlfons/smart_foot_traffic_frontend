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
import 'package:smart_foot_traffic_frontend/components/tools/export/export_report.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/widgets/filter/filter_tab.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/widgets/location/location_tab.dart';

// Custom widget Sidebar for page
class TrafficSidebar extends StatefulWidget {
  // Input parameters for the sidebar
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

  // Constructor for the sidebar
  // Accepts callbacks for location tap, generate, reset, and filter changes
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
    // Create a tab
    return DefaultTabController(
      // 2 tabs
      length: 2,
      // Column from up to down
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top row contents
              Row(
                children: [
                  // Menu Button
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
              // In the same line, right side contents
              InkWell(
                // Function to export
                onTap: () => downloadReport(
                  // Will take in the parameters
                  context: context,
                  date: widget.selectedDate,
                  time: widget.selectedTime,
                  trafficType: widget.selectedTrafficType,
                ),
                hoverColor: Colors.transparent,
                child: Row(
                  children: [
                    // Export button with hover effect
                    HoverableIconButton(
                      onPressed: () => downloadReport(
                        context: context,
                        date: widget.selectedDate,
                        time: widget.selectedTime,
                        trafficType: widget.selectedTrafficType,
                      ),
                      icon: const Icon(Icons.downloading_sharp),
                    ),
                    const SizedBox(width: 4),
                    // Export text
                    const Text(
                      "Export",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 2nd Row - Searchbar
          const SizedBox(height: 12),
          LocationSearchBar(
            query: widget.searchQuery,
            onChanged: widget.onSearchChanged!,
          ),
          const SizedBox(height: 12),
          // 3rd Row - TabBar with filters and location list
          Theme(
            // Custom theme for the TabBar
            data: Theme.of(context).copyWith(
              tabBarTheme: TabBarThemeData(
                // Tab text
                labelColor: Colors.yellow[700],
                // Unselected tab text
                unselectedLabelColor: Colors.white70,
              ),
            ),
            child: TabBar(
              // Color appears under the text
              indicatorColor: Colors.yellow[700],
              tabs: const [
                // Two tabs: List and Filters
                Tab(
                  child: Text(
                    'List',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
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
            // Expanded to fill the remaining space
            child: TabBarView(
              // Function to build the tab views
              children: [
                // First tab - Location list
                // Calls the LocationTab widget
                LocationTab(
                  // Has the snapshot
                  // data and onLocationTap callback
                  // And search query still applied
                  snapshotData: widget.snapshotData,
                  onLocationTap: widget.onLocationTap,
                  searchQuery: widget.searchQuery,
                ),
                // Second tab - Filters
                // Calls the FilterTab widget
                _buildFiltersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build the filters tab
  Widget _buildFiltersTab() {
    return FilterTab(
      // Pass all the filters and callbacks
      selectedType: widget.selectedTrafficType,
      selectedDate: widget.selectedDate,
      selectedTime: widget.selectedTime,
      selectedYear: selectedYear,
      selectedSeason: selectedSeason,
      onTypeChanged: widget.onTrafficTypeChanged,
      onDateChanged: widget.onDateChanged,
      onTimeChanged: widget.onTimeChanged,
      // Callbacks for year and season changes
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
      // Callbacks for generate and reset actions
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
