import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/components/buttons/hover.dart';

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
          const Text("Footscray Traffic",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          const TabBar(
            tabs: [
              Tab(text: 'List'),
              Tab(text: 'Filters'),
            ],
            indicatorColor: Colors.yellow,
          ),
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
          child: Text("No data available",
              style: TextStyle(color: Colors.white70)));
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dropdown(
              "Traffic Type",
              selectedTrafficType,
              ["Cyclist Count", "Pedestrian Count", "Vehicle Count"],
              onTrafficTypeChanged),
          _dropdown(
              "Time",
              selectedTime,
              List.generate(24, (i) => "${i.toString().padLeft(2, '0')}:00"),
              onTimeChanged),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                HoverableIconButton(
                  onPressed: () {
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
                  icon: const Icon(Icons.map),
                ),
                const SizedBox(height: 8),
                HoverableIconButton(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String? value, List<String> items,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          DropdownButton<String>(
            isExpanded: true,
            value: value,
            dropdownColor: Colors.black,
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            underline: Container(height: 1, color: Colors.yellow),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          )
        ],
      ),
    );
  }

  Widget _info(String title, String? value) {
    return ListTile(
      dense: true,
      title: Text("$title: $value",
          style: const TextStyle(color: Colors.white70, fontSize: 14)),
    );
  }
}
