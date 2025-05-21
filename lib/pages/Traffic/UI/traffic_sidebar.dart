import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/buttons/hover.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/widgets/filter/filter_tab.dart';

class TrafficSidebar extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Header row with padding
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HoverableIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                  const SizedBox(width: 6),
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

          // Search bar full width
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: const Color.fromARGB(255, 46, 46, 46),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),

          const SizedBox(height: 12),

          // Tab bar full width
          Theme(
            data: Theme.of(context).copyWith(
              tabBarTheme: TabBarTheme(
                labelColor: Colors.yellow[700],
                unselectedLabelColor: Colors.white70,
              ),
            ),
            child: TabBar(
              tabs: const [
                Tab(text: 'List'),
                Tab(text: 'Filters'),
              ],
              indicatorColor: Colors.yellow[700],
            ),
          ),

          // Tab view
          Expanded(
            child: TabBarView(
              children: [
                _buildListTab(),
                _buildFiltersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTab() {
    if (snapshotData == null || snapshotData!.isEmpty) {
      return const Center(
        child:
            Text("No data available", style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView(
      children: snapshotData!.entries.map((entry) {
        final location = entry.key;
        final data = entry.value;
        return ExpansionTile(
          title: Text(location, style: const TextStyle(color: Colors.white)),
          children: [
            _info("Type", data['type']),
            _info("Count", data['count'].toString()),
            _info("Date", data['date']),
            _info("Time", data['time']),
            _info("Season", data['season']),
            _info("Weather", data['weather']),
            _info("Temperature", data['temperature']),
          ],
          onExpansionChanged: (expanded) {
            if (expanded && onLocationTap != null) {
              onLocationTap!(location);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildFiltersTab() {
    return FilterTab(
      selectedType: selectedTrafficType,
      selectedDate: selectedDate,
      selectedTime: selectedTime,
      selectedYear: selectedYear,
      selectedSeason: selectedSeason,
      onTypeChanged: onTrafficTypeChanged,
      onDateChanged: onDateChanged,
      onTimeChanged: onTimeChanged,
      onYearChanged: (_) {},
      onSeasonChanged: (_) {},
      onGenerate: () {
        if (selectedDate != null &&
            selectedTime != null &&
            selectedTrafficType != null) {
          onGenerate(
            date: selectedDate!,
            time: selectedTime!,
            type: selectedTrafficType!,
            year: selectedYear,
            season: selectedSeason,
          );
        }
      },
      onReset: onReset,
    );
  }

  Widget _info(String title, String? value) {
    return ListTile(
      dense: true,
      title: Text(
        "$title: $value",
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}
