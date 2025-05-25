// ====================================================
// Filter Tab Panel
// ----------------------------------------------------
// - Lets users pick traffic type, date, time, year, season
// - Validates input before generating the heatmap
// - Handles reset with snack messages for feedback
// ====================================================

import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/widgets/filter/date.dart';

class FilterTab extends StatefulWidget {
  final String? selectedType;
  final String? selectedDate;
  final String? selectedTime;
  final String? selectedYear;
  final String? selectedSeason;

  final void Function(String?) onTypeChanged;
  final void Function(String?) onDateChanged;
  final void Function(String?) onTimeChanged;
  final void Function(String?) onYearChanged;
  final void Function(String?) onSeasonChanged;

  final VoidCallback onGenerate;
  final VoidCallback onReset;

  const FilterTab({
    super.key,
    required this.selectedType,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedYear,
    required this.selectedSeason,
    required this.onTypeChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onYearChanged,
    required this.onSeasonChanged,
    required this.onGenerate,
    required this.onReset,
  });

  @override
  State<FilterTab> createState() => _FilterTabState();
}

// Seasons
class _FilterTabState extends State<FilterTab> {
  List<String> seasonOptions = [
    "Season",
    "Summer",
    "Autumn",
    "Winter",
    "Spring"
  ];

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      // Alert message with red background
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _handleGenerate() {
    final date = widget.selectedDate;
    final time = widget.selectedTime;
    final type = widget.selectedType;
    final year = widget.selectedYear;
    final season = widget.selectedSeason;

    // Validate required fields
    if (date == null || time == null || type == null) {
      _showSnack("Date, Time, and Traffic Type are required.");
      return;
    }

    // Validate year and season selection
    final yearSelected = year != null && year.isNotEmpty;
    final seasonSelected = season != null && season.isNotEmpty;
    if ((yearSelected && !seasonSelected) ||
        (!yearSelected && seasonSelected)) {
      _showSnack("Please select both Year and Season together.");
      return;
    }

    widget.onGenerate();
  }

  void _handleReset() {
    widget.onReset();
    widget.onYearChanged("Year");
    widget.onSeasonChanged("Season");
    _showSnack("Filters have been reset.");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Traffic Type Dropdown
          _dropdown(
            "Traffic Type",
            widget.selectedType,
            ["Cyclist Count", "Pedestrian Count", "Vehicle Count"],
            widget.onTypeChanged,
          ),
          const SizedBox(height: 14),

          // Date Calendar
          DateDropdown(
            value: widget.selectedDate,
            onChanged: widget.onDateChanged,
            selectedYear: widget.selectedYear,
            selectedSeason: widget.selectedSeason,
          ),
          const SizedBox(height: 14),

          // Time Dropdown
          _dropdown(
            "Time",
            widget.selectedTime,
            List.generate(24, (i) => "${i.toString().padLeft(2, '0')}:00"),
            widget.onTimeChanged,
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24, thickness: 1, height: 16),
          const SizedBox(height: 12),

          // Year dropdown & validate season
          _dropdown(
            "Year",
            widget.selectedYear,
            ["Year", "2024", "2025"],
            (value) {
              widget.onYearChanged(value);
              widget.onSeasonChanged("Season");
              widget.onDateChanged(null);

              // Dynamically update season options
              setState(() {
                if (value == "2025") {
                  seasonOptions = ["Season", "Summer", "Autumn"];
                } else {
                  seasonOptions = [
                    "Season",
                    "Summer",
                    "Autumn",
                    "Winter",
                    "Spring"
                  ];
                }
              });
            },
          ),
          const SizedBox(height: 12),

          // Season dropdown
          _dropdown(
            "Season",
            widget.selectedSeason,
            seasonOptions,
            (value) {
              widget.onSeasonChanged(value);
              widget.onDateChanged(null);
            },
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24, thickness: 1, height: 16),
          const SizedBox(height: 22),

          // Generate button
          ElevatedButton(
            onPressed: _handleGenerate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Generate Heatmap'),
          ),
          const SizedBox(height: 12),

          // Reset button
          ElevatedButton(
            onPressed: _handleReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }

  // Helper method to create dropdown widgets
  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      iconEnabledColor: Colors.white,
      dropdownColor: const Color.fromARGB(255, 46, 46, 46),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        filled: false,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow[700]!),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(e, overflow: TextOverflow.ellipsis),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
