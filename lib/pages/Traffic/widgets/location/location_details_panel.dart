import 'package:flutter/material.dart';

class LocationDetailsPanel extends StatelessWidget {
  final String type;
  final String count;
  final String date;
  final String time;
  final String season;
  final String weather;
  final String temperature;

  const LocationDetailsPanel({
    super.key,
    required this.type,
    required this.count,
    required this.date,
    required this.time,
    required this.season,
    required this.weather,
    required this.temperature,
  });

  String getTimeRange(String rawTime) {
    try {
      final parts = rawTime.split(":");
      final hour = int.parse(parts[0]);
      final start = hour.toString().padLeft(2, "0");
      final end = (hour + 1).toString().padLeft(2, "0");
      return "$start:00 – $end:00";
    } catch (_) {
      return rawTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(Icons.directions_car, "Type", type),
        _InfoRow(Icons.confirmation_number, "Count", count),
        _InfoRow(Icons.calendar_today, "Date", date),
        _InfoRow(Icons.access_time, "Time", getTimeRange(time)),
        _InfoRow(Icons.park, "Season", season),
        _InfoRow(Icons.cloud, "Weather", weather),
        _InfoRow(Icons.thermostat, "Temperature", "$temperature°C"),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
