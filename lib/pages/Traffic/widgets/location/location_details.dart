import 'package:flutter/material.dart';

class LocationDetailsPanel extends StatelessWidget {
  final Map<String, dynamic>? data;

  const LocationDetailsPanel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "No data available.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final rawTime = data?['time']?.toString() ?? '';
    final timeDisplay = rawTime.isNotEmpty ? _formatTimeRange(rawTime) : 'N/A';

    final temp = data?['temperature'];
    final temperatureDisplay = temp != null ? "$temp°C" : 'N/A';

    return Column(
      children: [
        _info(Icons.directions_car, "Type",
            data?['traffic_type'] ?? data?['type']),
        _info(Icons.confirmation_number, "Count", data?['count']),
        _info(Icons.calendar_today, "Date", data?['date']),
        _info(Icons.access_time, "Time", timeDisplay),
        _info(Icons.park, "Season", data?['season']),
        _info(Icons.cloud, "Weather", data?['weather']),
        _info(Icons.thermostat, "Temperature", temperatureDisplay),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _info(IconData icon, String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              "$title:",
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value?.toString() ?? 'N/A',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRange(String time) {
    try {
      final parts = time.split(":");
      final hour = int.parse(parts[0]);
      final nextHour = (hour + 1) % 24;
      return "${hour.toString().padLeft(2, '0')}:00 – ${nextHour.toString().padLeft(2, '0')}:00";
    } catch (_) {
      return time;
    }
  }
}
